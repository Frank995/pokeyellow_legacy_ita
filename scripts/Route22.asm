Route22_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route22_ScriptPointers
	ld a, [wRoute22CurScript]
	jp CallFunctionInTable

Route22_ScriptPointers:
	def_script_pointers
	dw_const Route22DefaultScript,           SCRIPT_ROUTE22_DEFAULT
	dw_const Route22Rival1StartBattleScript, SCRIPT_ROUTE22_RIVAL1_START_BATTLE
	dw_const Route22Rival1AfterBattleScript, SCRIPT_ROUTE22_RIVAL1_AFTER_BATTLE
	dw_const Route22Rival1ExitScript,        SCRIPT_ROUTE22_RIVAL1_EXIT
	dw_const Route22Rival2StartBattleScript, SCRIPT_ROUTE22_RIVAL2_START_BATTLE
	dw_const Route22Rival2AfterBattleScript, SCRIPT_ROUTE22_RIVAL2_AFTER_BATTLE
	dw_const Route22Rival2ExitScript,        SCRIPT_ROUTE22_RIVAL2_EXIT
	dw_const Route22NoopScript,              SCRIPT_ROUTE22_NOOP

Route22SetDefaultScript:
	xor a ; SCRIPT_ROUTE22_DEFAULT
	ld [wJoyIgnore], a
	ld [wRoute22CurScript], a

Route22RivalMoveRightScript:
	ld de, Route22RivalMovementData
	ld a, [wSavedCoordIndex]
	cp $1
	jr z, .skip_first_right
	inc de
.skip_first_right
	call MoveSprite
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	jp SetSpriteFacingDirectionAndDelay

Route22RivalMovementData:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

Route22DefaultScript:
	; Check if rival wants to battle
	CheckEvent EVENT_ROUTE_22_RIVAL_WANTS_BATTLE
	ret z

	; Check if player is in the right coords
	ld hl, Route22RivalBattleCoords
	call ArePlayerCoordsInArray
	ret nc

	; Stop player
	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a

	CheckEvent EVENT_ROUTE_22_RIVAL1_BATTLE
	jr nz, Route22Rival1BattleScript
	CheckEventReuseA EVENT_ROUTE_22_RIVAL2_BATTLE
	jp nz, Route22Rival2BattleScript
	ret

Route22RivalBattleCoords:
	dbmapcoord 29,  4
	dbmapcoord 29,  5
	db -1 ; end

Route22Rival1BattleScript:
	ld a, ROUTE22_RIVAL
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .walking
	call StopAllMusic
.walking
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, ROUTE22_RIVAL
	ldh [hSpriteIndex], a
	call Route22RivalMoveRightScript

	ld a, SCRIPT_ROUTE22_RIVAL1_START_BATTLE
	ld [wRoute22CurScript], a
	ret

Route22Rival1StartBattleScript:
	; Wait for movement to finish
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Set player direction
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, lower entry in Route22RivalBattleCoords
	jr nz, .set_rival_facing_right
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	jr .set_rival_facing_direction
.set_rival_facing_right
	ld a, SPRITE_FACING_RIGHT
.set_rival_facing_direction
	ldh [hSpriteFacingDirection], a
	ld a, ROUTE22_RIVAL
	ldh [hSpriteIndex], a
	call SetSpriteFacingDirectionAndDelay

	; Enable input and start battle
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_ROUTE22_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, Route22Rival1DefeatedText
	ld de, Route22Rival1VictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL1
	ld [wCurOpponent], a
	ld a, 2
	ld [wTrainerNo], a

	ld a, SCRIPT_ROUTE22_RIVAL1_AFTER_BATTLE
	ld [wRoute22CurScript], a
	ret

Route22Rival1AfterBattleScript:
	; If player lost return to default script
	ld a, [wIsInBattle]
	cp $ff
	jp z, Route22SetDefaultScript

	; Change starter
	ld a, [wRivalStarter]
	cp RIVAL_STARTER_FLAREON
	jr nz, .keep_rival_starter
	ld a, RIVAL_STARTER_JOLTEON
	ld [wRivalStarter], a
.keep_rival_starter

	; Set rival facing direction
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .not_facing_down
	ld a, SPRITE_FACING_UP
	jr .set_rival_facing
.not_facing_down
	ld a, SPRITE_FACING_RIGHT
.set_rival_facing
	ldh [hSpriteFacingDirection], a
	ld a, ROUTE22_RIVAL
	ldh [hSpriteIndex], a
	call SetSpriteFacingDirectionAndDelay

	; Block input again
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_ROUTE_22_BEAT_RIVAL1
	ld a, TEXT_ROUTE22_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	call StopAllMusic
	farcall Music_RivalAlternateStart

	; Rival exits
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, lower entry in Route22RivalBattleCoords
	jr nz, .exit_movement_2
	call Route22Rival1Exit1Script
	jr .next_script
.exit_movement_2
	call Route22Rival1Exit2Script
.next_script
	ld a, SCRIPT_ROUTE22_RIVAL1_EXIT
	ld [wRoute22CurScript], a
	ret

Route22Rival1Exit1Script:
	ld de, Route22Rival1Exit1MovementData
	jr Route22MoveRival1

Route22Rival1Exit2Script:
	ld de, Route22Rival1Exit2MovementData
	jr Route22MoveRival1

Route22MoveRival1:
	ld a, ROUTE22_RIVAL
	ldh [hSpriteIndex], a
	jp MoveSprite

Route22Rival1Exit1MovementData:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

Route22Rival1Exit2MovementData:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

Route22Rival1ExitScript:
	; Wait for movement to finish
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Reenable input and hide object
	xor a
	ld [wJoyIgnore], a
	ld a, HS_ROUTE_22_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	call DelayFrame
	call PlayDefaultMusic
	ResetEvents EVENT_ROUTE_22_RIVAL1_BATTLE, EVENT_ROUTE_22_RIVAL_WANTS_BATTLE

	ld a, SCRIPT_ROUTE22_DEFAULT
	ld [wRoute22CurScript], a
	ret

Route22Rival2BattleScript:
	ld a, ROUTE22_RIVAL
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .walking
	call StopAllMusic
.walking
	call StopAllMusic
	farcall Music_RivalAlternateTempo
	ld a, ROUTE22_RIVAL
	ldh [hSpriteIndex], a
	call Route22RivalMoveRightScript
	ld a, SCRIPT_ROUTE22_RIVAL2_START_BATTLE
	ld [wRoute22CurScript], a
	ret

Route22Rival2StartBattleScript:
	; Wait for movement to finish
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Set player direction
	ld a, ROUTE22_RIVAL
	ldh [hSpriteIndex], a
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, lower entry in Route22DefaultScript.Route22RivalBattleCoords
	jr nz, .set_player_direction_left
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	jr .set_rival_facing_direction
.set_player_direction_left
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_RIGHT
.set_rival_facing_direction
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Enable input and start battle
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_ROUTE22_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, Route22Rival2DefeatedText
	ld de, Route22Rival2VictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL2
	ld [wCurOpponent], a
	ld a, [wRivalStarter]
	add 7
	ld [wTrainerNo], a

	ld a, SCRIPT_ROUTE22_RIVAL2_AFTER_BATTLE
	ld [wRoute22CurScript], a
	ret

Route22Rival2AfterBattleScript:
	; If player lost return to default script
	ld a, [wIsInBattle]
	cp $ff
	jp z, Route22SetDefaultScript

	; Set player facing direction
	ld a, ROUTE22_RIVAL
	ldh [hSpriteIndex], a
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, lower entry in Route22RivalBattleCoords
	jr nz, .set_player_direction_left
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	jr .set_rival_facing_direction
.set_player_direction_left
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_RIGHT
.set_rival_facing_direction
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Block input again
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_ROUTE_22_BEAT_RIVAL2
	ld a, TEXT_ROUTE22_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	call StopAllMusic
	farcall Music_RivalAlternateStartAndTempo

	; Rival exits
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, lower entry in Route22RivalBattleCoords
	jr nz, .exit_movement_2
	call Route22Rival2Exit1Script
	jr .next_script
.exit_movement_2
	call Route22Rival2Exit2Script
.next_script
	ld a, SCRIPT_ROUTE22_RIVAL2_EXIT
	ld [wRoute22CurScript], a
	ret

Route22Rival2Exit1Script:
	ld de, Route22Rival2Exit1MovementData
	jr Route22MoveRival2

Route22Rival2Exit2Script:
	ld de, Route22Rival2Exit2MovementData
	jr Route22MoveRival2

Route22MoveRival2:
	ld a, ROUTE22_RIVAL
	ldh [hSpriteIndex], a
	jp MoveSprite

Route22Rival2Exit1MovementData:
	db NPC_MOVEMENT_LEFT

Route22Rival2Exit2MovementData:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1 ; end

Route22Rival2ExitScript:
	; Wait for movement to finish
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Reenable input and hide object
	xor a
	ld [wJoyIgnore], a
	ld a, HS_ROUTE_22_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	call PlayDefaultMusic
	ResetEvents EVENT_ROUTE_22_RIVAL2_BATTLE, EVENT_ROUTE_22_RIVAL_WANTS_BATTLE

	ld a, SCRIPT_ROUTE22_NOOP
	ld [wRoute22CurScript], a
	ret

Route22NoopScript:
	ret

Route22_TextPointers:
	def_text_pointers
	dw_const Route22RivalText,             TEXT_ROUTE22_RIVAL
	dw_const Route22PokemonLeagueSignText, TEXT_ROUTE22_POKEMON_LEAGUE_SIGN

Route22RivalText:
	text_asm
	farcall Route22PrintRivalText
	jp TextScriptEnd

Route22Rival1DefeatedText:
	text_far _Route22Rival1DefeatedText
	text_end

Route22Rival1VictoryText:
	text_far _Route22Rival1VictoryText
	text_end

Route22Rival2DefeatedText:
	text_far _Route22Rival2DefeatedText
	text_end

Route22Rival2VictoryText:
	text_far _Route22Rival2VictoryText
	text_end

Route22PokemonLeagueSignText:
	text_far _Route22PokemonLeagueSignText
	text_end
