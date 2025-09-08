SSAnne2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSAnne2F_ScriptPointers
	ld a, [wSSAnne2FCurScript]
	jp CallFunctionInTable

SSAnne2F_ScriptPointers:
	def_script_pointers
	dw_const SSAnne2FRivalCheckScript,      SCRIPT_SSANNE2F_RIVAL_CHECK
	dw_const SSAnne2FRivalWalkScript,       SCRIPT_SSANNE2F_RIVAL_WALK
	dw_const SSAnne2FRivalBattleScript,     SCRIPT_SSANNE2F_RIVAL_BATTLE
	dw_const SSAnne2FRivalPostBattleScript, SCRIPT_SSANNE2F_RIVAL_POST_BATTLE
	dw_const SSAnne2FRivalExitScript,       SCRIPT_SSANNE2F_RIVAL_EXIT
	dw_const SSAnne2FNoopScript,            SCRIPT_SSANNE2F_NOOP

SSAnne2FRivalCoordinatesArray:
	dbmapcoord 36,  9
	dbmapcoord 37,  9
	db -1 ; end

SSAnne2FRivalCheckScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC

	CheckEvent EVENT_SS_ANNE_BEAT_RIVAL
	jr nz, .skip_check

	; Check for coordinates
	ld hl, SSAnne2FRivalCoordinatesArray
	call ArePlayerCoordsInArray
	ret nc

	; Block input
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Play music
	call StopAllMusic
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic

	ld a, SCRIPT_SSANNE2F_RIVAL_WALK
	ld [wSSAnne2FCurScript], a
	ld [wCurMapScript], a
	ret

.skip_check
	ld a, SCRIPT_SSANNE2F_NOOP
	ld [wSSAnne2FCurScript], a
	ld [wCurMapScript], a
	ret

SSAnne2FRivalMovement1:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

SSAnne2FRivalWalkScript:
	; Is the player standing on the right side of the deck
	ld a, [wXCoord]
	cp 37
	jr z, .player_right_side

	; Shift the rival if on the wrong side
	ld a, SSANNE2F_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA2_MAPX
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData2
	ld [hl], 40
.player_right_side
	; Move rival
	ld de, SSAnne2FRivalMovement1
	ld a, SSANNE2F_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_SSANNE2F_RIVAL_BATTLE
	ld [wSSAnne2FCurScript], a
	ld [wCurMapScript], a
	ret

SSAnne2FRivalBattleScript:
	; Wait for movement to finish
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Enable input
	xor a
	ld [wJoyIgnore], a

	; Load text
	ld a, TEXT_SSANNE2F_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	ret

SSAnne2FRivalPostBattleScript:
	; If the player lost, reset event
	ld a, [wIsInBattle]
	inc a
	jr z, .skip

	; Block input again
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Face down rival
	ld a, SSANNE2F_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Show text
	ld a, TEXT_SSANNE2F_RIVAL_CUT_MASTER
	ldh [hTextID], a
	call DisplayTextID

	; Move rival
	SetEvent EVENT_SS_ANNE_BEAT_RIVAL
	call StopAllMusic
	farcall Music_RivalAlternateStart
	ld a, SSANNE2F_RIVAL
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, [wXCoord]
	cp 37 ; is the player standing on the right side of the bridge?
	jr z, .playerOnRightSideOfBridge
	ld de, SSAnne2FRivalMovement2
	jr .move
.playerOnRightSideOfBridge
	ld de, SSAnne2FRivalMovement3
.move
	ld a, SSANNE2F_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_SSANNE2F_RIVAL_EXIT
	ld [wSSAnne2FCurScript], a
	ld [wCurMapScript], a
	ret
.skip
	xor a ; SCRIPT_SSANNE2F_RIVAL_CHECK
	ld [wSSAnne2FCurScript], a
	ld [wCurMapScript], a
	ret

SSAnne2FRivalMovement2:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

SSAnne2FRivalMovement3:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

SSAnne2FRivalExitScript:
	; Wait for finishing movement
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Enable input hide rival and play default music
	xor a
	ld [wJoyIgnore], a
	ld a, HS_SS_ANNE_2F_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_SS_ANNE_3F_SAILOR
	ld [wMissableObjectIndex], a
	predef HideObject
	call PlayDefaultMusic
	

	ld a, SCRIPT_SSANNE2F_NOOP
	ld [wSSAnne2FCurScript], a
	ld [wCurMapScript], a
	ret

SSAnne2FNoopScript:
	ret

SSAnne2F_TextPointers:
	def_text_pointers
	dw_const SSAnne2FWaiterText,         TEXT_SSANNE2F_WAITER
	dw_const SSAnne2FRivalText,          TEXT_SSANNE2F_RIVAL
	dw_const SSAnne2FRivalCutMasterText, TEXT_SSANNE2F_RIVAL_CUT_MASTER

SSAnne2FWaiterText:
	text_far _SSAnne2FWaiterText
	text_end

SSAnne2FRivalText:
	text_asm

	; Start battle
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	call Delay3
	ld a, OPP_RIVAL2
	ld [wCurOpponent], a
	ld a, 1
	ld [wTrainerNo], a

	; Change map script
	ld a, SCRIPT_SSANNE2F_RIVAL_POST_BATTLE
	ld [wSSAnne2FCurScript], a
	ld [wCurMapScript], a

	ld hl, SSAnne2FRivalDefeatedText
	ld de, SSAnne2FRivalDefeatedText
	call SaveEndBattleTextPointers

	ld hl, SSAnne2FRivalStartBattleText
	call PrintText
	jp TextScriptEnd

SSAnne2FRivalStartBattleText:
	text_far _SSAnne2FRivalStartBattleText
	text_end

SSAnne2FRivalDefeatedText:
	text_far _SSAnne2FRivalDefeatedText
	text_end

SSAnne2FRivalVictoryText:
	text_far _SSAnne2FRivalVictoryText
	text_end

SSAnne2FRivalCutMasterText:
	text_far _SSAnne2FRivalCutMasterText
	text_end
