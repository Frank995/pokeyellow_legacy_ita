OaksLab_Script:
	call EnableAutoTextBoxDrawing
	ld hl, OaksLab_ScriptPointers
	ld a, [wOaksLabCurScript]
	jp CallFunctionInTable

OaksLab_ScriptPointers:
	def_script_pointers
	dw_const OaksLabStarterCheckScript,               SCRIPT_OAKSLAB_STARTER_CHECK
	dw_const OaksLabStarterPlayerMovesUpScript,       SCRIPT_OAKSLAB_STARTER_PLAYER_MOVES_UP
	dw_const OaksLabStarterRivalShowOffScript,        SCRIPT_OAKSLAB_STARTER_RIVAL_SHOW_OFF
	dw_const OaksLabStarterOakGivesMonScript,         SCRIPT_OAKSLAB_STARTER_OAK_GIVES_MON
	dw_const OaksLabStarterOakSpeechScript,           SCRIPT_OAKSLAB_STARTER_OAK_SPEECH
	dw_const OaksLabStarterRivalLeaveItToMeScript,    SCRIPT_OAKSLAB_STARTER_RIVAL_LEAVE_IT_TO_ME
	dw_const OaksLabStarterPlayerExitCheckScript,     SCRIPT_OAKSLAB_STARTER_PLAYER_EXIT_CHECK
	dw_const OaksLabStarterRivalStopsPlayerScript,    SCRIPT_OAKSLAB_STARTER_RIVAL_STOPS_PLAYER
	dw_const OaksLabStarterRivalMovesToPlayerScript,  SCRIPT_OAKSLAB_STARTER_RIVAL_MOVES_TO_PLAYER
	dw_const OaksLabStarterRivalBattleScript,         SCRIPT_OAKSLAB_STARTER_RIVAL_BATTLE
	dw_const OaksLabStarterRivalPostBattleScript,     SCRIPT_OAKSLAB_STARTER_RIVAL_POST_BATTLE
	dw_const OaksLabStarterRivalExitsScript,          SCRIPT_OAKSLAB_STARTER_RIVAL_EXITS
	dw_const OaksLabStarterPikachuEscapesBallScript,  SCRIPT_OAKSLAB_STARTER_PIKACHU_ESCAPES_BALL
	dw_const OaksLabStarterPlayerWatchRivalOutScript, SCRIPT_OAKSLAB_STARTER_PLAYER_WATCH_RIVAL_OUT
	dw_const OaksLabNoopScript,                       SCRIPT_OAKSLAB_NOOP

OaksLabStarterCheckScript:
	; Check if starter cutscene has already been played
	CheckEvent EVENT_PALLET_BATTLED_RIVAL
	jr nz, .skip_intro
	
	; Disable player input
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	; Start the intro cutscene
	ld a, SCRIPT_OAKSLAB_STARTER_PLAYER_MOVES_UP
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret
.skip_intro
	; Skip to noop script for normal gameplay
	ld a, SCRIPT_OAKSLAB_NOOP
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterPlayerMovesUpScript:
	; Move player toward oak tiles immediately
	ld a, 8  
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wSimulatedJoypadStatesEnd
	ld b, 8       ; number of loop steps
	ld a, PAD_UP
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	call StartSimulatingJoypadStates

	ld a, SCRIPT_OAKSLAB_STARTER_RIVAL_SHOW_OFF
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret


OaksLabStarterRivalShowOffScript:
	; Wait for player movement to complete
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	
	; Make rival and player face each other
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirection
	
	; Display message
	ld a, TEXT_OAKSLAB_STARTER_RIVAL_ATLAST
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	
	ld a, SCRIPT_OAKSLAB_STARTER_OAK_GIVES_MON
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterOakGivesMonScript:
	; Make both face Oak
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirection

	; Oak dialogue
	ld a, TEXT_OAKSLAB_STARTER_OAK_GIVES_MON
	ldh [hTextID], a
	call DisplayTextID

	ld a, SCRIPT_OAKSLAB_STARTER_OAK_SPEECH
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterOakSpeechScript:
	; Wait a little
	ld c, 20
	call DelayFrames

	; Start dialogue
	ld a, TEXT_OAKSLAB_STARTER_OAK_ONE_MORE_THING
	ldh [hTextID], a
	call DisplayTextID
	call DelayFrame
	call Delay3

	ld a, TEXT_OAKSLAB_STARTER_POKEDEX_EXPLANATION
	ldh [hTextID], a
	call DisplayTextID
	call DelayFrame
	call Delay3

	ld a, TEXT_OAKSLAB_STARTER_POKEDEX_RECEIVED
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	; Hide pokedexes
	ld a, HS_OAKS_LAB_POKEDEX_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_OAKS_LAB_POKEDEX_2
	ld [wMissableObjectIndex], a
	predef HideObject

	ld a, TEXT_OAKSLAB_STARTER_OAKS_DREAM
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	ld a, TEXT_OAKSLAB_STARTER_OAK_GIVES_BALLS
	ldh [hTextID], a
	call DisplayTextID
	lb bc, POKE_BALL, 5
	call GiveItem
	call Delay3

	ld a, SCRIPT_OAKSLAB_STARTER_RIVAL_LEAVE_IT_TO_ME
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterRivalLeaveItToMeScript:
	SetEvent EVENT_PALLET_GOT_POKEDEX
	ld a, TEXT_OAKSLAB_STARTER_RIVAL_LEAVE_IT_TO_ME
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	; Make rival and player face each other
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirection

	ld a, TEXT_OAKSLAB_STARTER_RIVAL_DONT_NEED_YOU
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	; Allow player input again
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_STARTER_PLAYER_EXIT_CHECK
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterPlayerExitCheckScript:
	; Check if player tries to go toward exit (south)
	ld a, [wYCoord]
	cp 6  ; If player reaches this coordinate, they're trying to leave
	ret nz

	ld a, SCRIPT_OAKSLAB_STARTER_RIVAL_STOPS_PLAYER
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterRivalStopsPlayerScript:
	; Stop the player and turn him up
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	; Rival faces down
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a ; face down
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Play music
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic

	; Print stop text
	ld a, TEXT_OAKSLAB_STARTER_RIVAL_STOPS_PLAYER
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	ld a, SCRIPT_OAKSLAB_STARTER_RIVAL_MOVES_TO_PLAYER
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterRivalMovesToPlayerScript:
	; Move rival toward player
	ld a, $1
	ldh [hNPCPlayerRelativePosPerspective], a
	ld a, $1
	swap a
	ldh [hNPCPlayerYDistance], a
	predef CalcPositionOfPlayerRelativeToNPC
	ldh a, [hNPCPlayerYDistance]
	dec a
	ldh [hNPCPlayerYDistance], a
	predef FindPathToPlayer
	ld de, wNPCMovementDirections2
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite
	
	ld a, SCRIPT_OAKSLAB_STARTER_RIVAL_BATTLE
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterRivalBattleScript:
	; Wait for rival movement to complete
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	
	; Enable input
	xor a
	ld [wJoyIgnore], a

	; Player looks up
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	; Set up battle
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call GetSpritePosition1
	ld a, OPP_RIVAL1
	ld [wCurOpponent], a
	ld a, 1
	ld [wTrainerNo], a
	ld hl, OaksLabStarterRivalBattleLostText
	ld de, OaksLabStarterRivalBattleWonText
	call SaveEndBattleTextPointers
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	
	ld a, SCRIPT_OAKSLAB_STARTER_RIVAL_POST_BATTLE
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterRivalPostBattleScript:
	; Disable player input
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Face rival up
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Heal party and set event
	predef HealParty
	SetEvent EVENT_PALLET_BATTLED_RIVAL

	ld a, SCRIPT_OAKSLAB_STARTER_RIVAL_EXITS
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterRivalExitsScript:
	; Delay a bit
	ld c, 20
	call DelayFrames

	; Exit dialogue to OAK
	ld a, TEXT_OAKSLAB_STARTER_RIVAL_EXITS
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	; Exit dialogue to player
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_OAKSLAB_STARTER_RIVAL_TOWN_MAP
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	; Move rival out
	farcall Music_RivalAlternateStart
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld de, OaksLabStarterRivalExitsMovement
	call MoveSprite
	ld a, [wXCoord]
	cp 4
	; move left or right depending on where the player is standing
	jr nz, .moveLeft
	ld a, NPC_MOVEMENT_RIGHT
	jr .next
.moveLeft
	ld a, NPC_MOVEMENT_LEFT
.next
	ld [wNPCMovementDirections], a

	ld a, SCRIPT_OAKSLAB_STARTER_PLAYER_WATCH_RIVAL_OUT
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabStarterRivalExitsMovement:
	db NPC_CHANGE_FACING
	db NPC_MOVEMENT_DOWN
	db $04
	db $04
	db $04
	db $04
	db $04
	db -1 ; end

OaksLabStarterPlayerWatchRivalOutScript:
	; Wait for movement to finish
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	jr nz, .checkRivalPosition

	; Hide rival
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	call PlayDefaultMusic

	ld a, SCRIPT_OAKSLAB_STARTER_PIKACHU_ESCAPES_BALL
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

; make the player keep facing the rival as he walks away
.checkRivalPosition
	ld a, [wNPCNumScriptedSteps]
	cp $5
	jr nz, .turnPlayerDown
	ld a, [wXCoord]
	cp 4
	jr nz, .turnPlayerLeft
	ld a, SPRITE_FACING_RIGHT
	jr .done
.turnPlayerLeft
	ld a, SPRITE_FACING_LEFT
	jr .done
.turnPlayerDown
	cp $4
	ret nz
	xor a ; ld a, SPRITE_FACING_DOWN
.done
	ld [wSpritePlayerStateData1FacingDirection], a
	ret

OaksLabStarterPikachuEscapesBallScript:
	; Pikachu comes out
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, $2
	ld [wPikachuSpawnState], a
	farcall SchedulePikachuSpawnForAfterText
	call EnablePikachuOverworldSpriteDrawing

	; Allow player to move
	xor a
	ld [wJoyIgnore], a

	ld a, TEXT_OAKSLAB_STARTER_PIKACHU_ESCAPES_BALL
	ldh [hTextID], a
	call DisplayTextID
	
	ld a, SCRIPT_OAKSLAB_NOOP
	ld [wOaksLabCurScript], a
	ld [wCurMapScript], a
	ret

OaksLabNoopScript:
	ret

; Update text pointers to include new texts
OaksLab_TextPointers:
	def_text_pointers
	dw_const OaksLabRivalText,                     TEXT_OAKSLAB_RIVAL
	dw_const OaksLabOakText,                       TEXT_OAKSLAB_OAK
	dw_const OaksLabPokedexText,                   TEXT_OAKSLAB_POKEDEX1
	dw_const OaksLabPokedexText,                   TEXT_OAKSLAB_POKEDEX2
	dw_const OaksLabGirlText,                      TEXT_OAKSLAB_GIRL
	dw_const OaksLabScientistText,                 TEXT_OAKSLAB_SCIENTIST1
	dw_const OaksLabScientistText,                 TEXT_OAKSLAB_SCIENTIST2
	dw_const OaksLabStarterRivalAtLastText,        TEXT_OAKSLAB_STARTER_RIVAL_ATLAST
	dw_const OaksLabStarterOakGivesMonText,        TEXT_OAKSLAB_STARTER_OAK_GIVES_MON
	dw_const OaksLabStarterOakOneMoreThingText,    TEXT_OAKSLAB_STARTER_OAK_ONE_MORE_THING
	dw_const OaksLabStarterPokedexExplanationText, TEXT_OAKSLAB_STARTER_POKEDEX_EXPLANATION
	dw_const OaksLabStarterPokedexReceivedText,    TEXT_OAKSLAB_STARTER_POKEDEX_RECEIVED
	dw_const OaksLabStarterOaksDreamText,          TEXT_OAKSLAB_STARTER_OAKS_DREAM
	dw_const OaksLabStarterOakGivesBallsText,      TEXT_OAKSLAB_STARTER_OAK_GIVES_BALLS
	dw_const OaksLabStarterRivalLeaveItToMeText,   TEXT_OAKSLAB_STARTER_RIVAL_LEAVE_IT_TO_ME
	dw_const OaksLabStarterRivalDontNeedYouText,   TEXT_OAKSLAB_STARTER_RIVAL_DONT_NEED_YOU
	dw_const OaksLabStarterRivalStopsPlayerText,   TEXT_OAKSLAB_STARTER_RIVAL_STOPS_PLAYER
	dw_const OaksLabStarterRivalExitsText,         TEXT_OAKSLAB_STARTER_RIVAL_EXITS
	dw_const OaksLabStarterRivalTownMapText,       TEXT_OAKSLAB_STARTER_RIVAL_TOWN_MAP
	dw_const OaksLabStarterPikachuEscapesBallText, TEXT_OAKSLAB_STARTER_PIKACHU_ESCAPES_BALL

OaksLabRivalText:
	text_far _OaksLabRivalText
	text_end

OaksLabOakText:
	text_asm
	callfar OaksLabPrintOakText
	jp TextScriptEnd

OaksLabPokedexText:
	text_far _OaksLabPokedexText
	text_end

OaksLabGirlText:
	text_far _OaksLabGirlText
	text_end

OaksLabScientistText:
	text_far _OaksLabScientistText
	text_end

OaksLabStarterRivalAtLastText:
	text_far _OaksLabStarterRivalAtLastText
	text_end

OaksLabStarterOakGivesMonText:
	text_asm
	ld a, STARTER_PIKACHU
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabStarterSentPikachuText
	call PrintText
	ld hl, OaksLabStarterReceivedPikachuText
	call PrintText
	xor a
	ld [wMonDataLocation], a
	ld a, 5
	ld [wCurEnemyLevel], a
	ld a, STARTER_PIKACHU
	ld [wPokedexNum], a
	ld [wCurPartySpecies], a
	call AddPartyMon
	ld a, LIGHT_BALL_GSC
	ld [wPartyMon1CatchRate], a
	call DisablePikachuOverworldSpriteDrawing
	SetEvent EVENT_PALLET_GOT_PIKACHU
	ld hl, wStatusFlags4
	set BIT_GOT_STARTER, [hl]
	jp TextScriptEnd

OaksLabStarterSentPikachuText:
	text_far _OaksLabStarterSentPikachuText
	text_end

OaksLabStarterReceivedPikachuText:
	text_far _OaksLabStarterReceivedPikachuText
	sound_get_key_item
	text_end

OaksLabStarterPikachuEscapesBallText:
	text_asm
	ldpikacry e, PikachuCry2
	callfar PlayPikachuSoundClip
	ld hl, OaksLabStarterWildPikachuText
	call PrintText
	jp TextScriptEnd

OaksLabStarterWildPikachuText:
	text_far _OaksLabStarterWildPikachuText
	text_end

OaksLabStarterOakOneMoreThingText:
	text_far _OaksLabStarterOakOneMoreThingText
	text_end

OaksLabStarterPokedexExplanationText:
	text_far _OaksLabStarterPokedexExplanationText
	text_end

OaksLabStarterPokedexReceivedText:
	text_far _OaksLabStarterPokedexReceivedText
	sound_get_key_item
	text_end

OaksLabStarterOaksDreamText:
	text_far _OaksLabStarterOaksDreamText
	text_end

OaksLabStarterOakGivesBallsText:
	text_far _OaksLabStarterOakGivesBallsText
	sound_get_key_item
	text_end

OaksLabStarterRivalLeaveItToMeText:
	text_far _OaksLabStarterRivalLeaveItToMeText
	text_end

OaksLabStarterRivalDontNeedYouText:
	text_far _OaksLabStarterRivalDontNeedYouText
	text_end

OaksLabStarterRivalStopsPlayerText:
	text_far _OaksLabRivalStopsPlayerText
	text_end

OaksLabStarterRivalBattleLostText:
	text_far _OaksLabStarterRivalBattleLostText
	text_end

OaksLabStarterRivalBattleWonText:
	text_far _OaksLabStarterRivalBattleWonText
	text_end

OaksLabStarterRivalExitsText:
	text_far _OaksLabStarterRivalExitsText
	text_end

OaksLabStarterRivalTownMapText:
	text_far _OaksLabStarterRivalTownMapText
	text_end
