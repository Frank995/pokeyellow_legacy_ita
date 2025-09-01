MtMoonShrine_Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonShrine_ScriptPointers
	ld a, [wMtMoonShrineCurScript]
	jp CallFunctionInTable

MtMoonShrine_ScriptPointers:
	def_script_pointers
	dw_const MtMoonShrineJJStartScript,             SCRIPT_MTMOONSHRINE_JJ_START
	dw_const MtMoonShrineJJExclamationBubbleScript, SCRIPT_MTMOONSHRINE_JJ_EXCLAMATION_BUBBLE
	dw_const MtMoonShrineJJMovePlayerScript,        SCRIPT_MTMOONSHRINE_JJ_MOVE_PLAYER
	dw_const MtMoonShrineJJSeymourScript,           SCRIPT_MTMOONSHRINE_JJ_SEYMOUR
	dw_const MtMoonShrineJJFearNotScript,           SCRIPT_MTMOONSHRINE_JJ_FEAR_NOT
	dw_const MtMoonShrineJJQuestionBubbleScript,    SCRIPT_MTMOONSHRINE_JJ_QUESTION_BUBBLE
	dw_const MtMoonShrineJJAppearScript,            SCRIPT_MTMOONSHRINE_JJ_APPEAR
	dw_const MtMoonShrineJJSpeechScript,            SCRIPT_MTMOONSHRINE_JJ_SPEECH
	dw_const MtMoonShrineJJPostBattleScript,        SCRIPT_MTMOONSHRINE_JJ_POST_BATTLE
	dw_const MtMoonShrineJJWhatsHappeningScript,    SCRIPT_MTMOONSHRINE_JJ_WHATS_HAPPENING
	dw_const MtMoonShrineJJMetronomeScript,         SCRIPT_MTMOONSHRINE_JJ_METRONOME
	dw_const MtMoonShrineJJClearUpScript,           SCRIPT_MTMOONSHRINE_JJ_CLEAR_UP
	dw_const MtMoonShrineNoopScript,                SCRIPT_MTMOONSHRINE_NOOP

MtMoonShrineJJStartScript:
	; Check if event already completed
	CheckEvent EVENT_MT_MOON_SHRINE_BEAT_JJ
	jr nz, .skip_event
	
	; Block player input immediately
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	ld a, SCRIPT_MTMOONSHRINE_JJ_EXCLAMATION_BUBBLE
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret
.skip_event
	ld a, SCRIPT_MTMOONSHRINE_NOOP
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJExclamationBubbleScript:
	; Small initial delay
	ld c, 20
	call DelayFrames
	
	; Show exclamation bubble on player
	ld a, 0  ; player's sprite index
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	
	; Wait for bubble animation
	ld c, 30
	call DelayFrames
	
	ld a, SCRIPT_MTMOONSHRINE_JJ_MOVE_PLAYER
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJMovePlayerScript:
	; Move player one tile left and one up
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_LEFT
	ld [wSimulatedJoypadStatesEnd], a
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd + 1], a
	call StartSimulatingJoypadStates
	
	ld a, SCRIPT_MTMOONSHRINE_JJ_SEYMOUR
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJSeymourScript:
	; Wait for movement
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3

	; Player look up
	xor a ; player
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Display moon stone text
	ld a, TEXT_MTMOONSHRINE_JJ_MOON_STONE
	ldh [hTextID], a
	call DisplayTextID
	
	; Small delay (1 sec = 60 frames)
	ld c, 60
	call DelayFrames
	
	ld a, SCRIPT_MTMOONSHRINE_JJ_FEAR_NOT
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJFearNotScript:
	; Display intro text
	ld a, TEXT_MTMOONSHRINE_JJ_FEAR_NOT
	ldh [hTextID], a
	call DisplayTextID
	
	ld a, SCRIPT_MTMOONSHRINE_JJ_QUESTION_BUBBLE
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJQuestionBubbleScript:
	; Show question bubble on player
	ld a, 0  ; player's sprite index
	ld [wEmotionBubbleSpriteIndex], a
	ld a, QUESTION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	
	; Small delay (1 sec)
	ld c, 60
	call DelayFrames
	
	; Change music
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	
	ld a, SCRIPT_MTMOONSHRINE_JJ_APPEAR
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJAppearScript:
	; --- Jessie movement (down 4, left 1) ---
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a
	ld hl, wNPCMovementDirections2
	ld b, 4
.fillJessieDown:
	ld [hl], NPC_MOVEMENT_DOWN
	inc hl
	dec b
	jr nz, .fillJessieDown
	ld [hl], NPC_MOVEMENT_LEFT
	inc hl
	ld [hl], $ff
	
	ld a, MTMOONSHRINE_JESSIE
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	call MoveSprite
	
	ld a, [wSavedNPCMovementDirections2Index]
	ld [wNPCMovementDirections2Index], a
	
	; --- James movement (down 4, left 1) ---
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a
	ld hl, wNPCMovementDirections2
	ld b, 4
.fillJamesDown:
	ld [hl], NPC_MOVEMENT_DOWN
	inc hl
	dec b
	jr nz, .fillJamesDown
	ld [hl], NPC_MOVEMENT_LEFT
	inc hl
	ld [hl], $ff
	
	ld a, MTMOONSHRINE_JAMES
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	call MoveSprite
	
	ld a, [wSavedNPCMovementDirections2Index]
	ld [wNPCMovementDirections2Index], a
	
	ld a, SCRIPT_MTMOONSHRINE_JJ_SPEECH
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJSpeechScript:
	; Wait for sprites to finish moving
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Turn down
	ld a, MTMOONSHRINE_JESSIE
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, MTMOONSHRINE_JAMES
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Enable input
	xor a
	ld [wJoyIgnore], a

	; Speech
	ld a, TEXT_MTMOONSHRINE_JJ_SPEECH
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld a, TEXT_MTMOONSHRINE_JJ_MEOWTH
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	; Start battle
	ld a, TEXT_MTMOONSHRINE_JESSIE
	ldh [hTextID], a
	call DisplayTextID
	ret

MtMoonShrineJJPostBattleScript:
	; Check if the player lost
	ld a, [wIsInBattle]
	inc a  ; If wIsInBattle is -1 (lost), this sets z flag
	jr z, .playerLost

	; Block input again
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Delay
	ld c, 80
	call DelayFrames

	; Show bubbles on top of every char
	ld a, MTMOONSHRINE_JESSIE
	ld [wEmotionBubbleSpriteIndex], a
	ld a, QUESTION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble

	ld a, SCRIPT_MTMOONSHRINE_JJ_WHATS_HAPPENING
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret
.playerLost
	; Reset event for next visit
	ld a, SCRIPT_MTMOONSHRINE_JJ_START
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJWhatsHappeningScript:
	; Face left
	ld c, 30
	call DelayFrames
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	ld a, MTMOONSHRINE_JESSIE
	ldh [hSpriteIndex], a
	call SetSpriteFacingDirectionAndDelay
	call DelayFrame

	; Print text
	ld a, TEXT_MTMOONSHRINE_JJ_WHATS_HAPPENING
	ldh [hTextID], a
	call DisplayTextID

	ld a, SCRIPT_MTMOONSHRINE_JJ_METRONOME
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJMetronomeScript:
	ld c, 30
	call DelayFrames

	; Print warning
	ld a, TEXT_MTMOONSHRINE_JJ_METRONOME
	ldh [hTextID], a
	call DisplayTextID

	ld a, SCRIPT_MTMOONSHRINE_JJ_CLEAR_UP
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineJJClearUpScript:
	; White out animation to hide sprites
	call GBFadeOutToWhite
	ld c, 60
	call DelayFrames
	SetEvent EVENT_MT_MOON_SHRINE_BEAT_JJ
	ld a, HS_MT_MOON_SHRINE_JESSIE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_MT_MOON_SHRINE_JAMES
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromWhite

	ld a, TEXT_MTMOONSHRINE_JJ_DEFEATED
	ldh [hTextID], a
	call DisplayTextID

	ld a, SCRIPT_MTMOONSHRINE_NOOP
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonShrineNoopScript:
	ret

MtMoonShrine_TextPointers:
	def_text_pointers
	dw_const MtMoonShrineSeymourText,            TEXT_MTMOONSHRINE_SEYMOUR
	dw_const MtMoonShrineJJBattleText,           TEXT_MTMOONSHRINE_JESSIE
	dw_const MtMoonShrineJJBattleText,           TEXT_MTMOONSHRINE_JAMES
	dw_const MtMoonShrineClefairyText,           TEXT_MTMOONSHRINE_CLEFAIRY1
	dw_const MtMoonShrineClefairyText,           TEXT_MTMOONSHRINE_CLEFAIRY2
	dw_const MtMoonShrineClefairyText,           TEXT_MTMOONSHRINE_CLEFAIRY3
	dw_const MtMoonShrineClefairyText,           TEXT_MTMOONSHRINE_CLEFAIRY4
	dw_const MtMoonShrineJJMoonStoneText,        TEXT_MTMOONSHRINE_JJ_MOON_STONE
	dw_const MtMoonShrineJJFearNotText,          TEXT_MTMOONSHRINE_JJ_FEAR_NOT
	dw_const MtMoonShrineJJSpeechText,           TEXT_MTMOONSHRINE_JJ_SPEECH
	dw_const MtMoonShrineJJMeowthText,           TEXT_MTMOONSHRINE_JJ_MEOWTH
	dw_const MtMoonShrineJJWhatsHappeningText,   TEXT_MTMOONSHRINE_JJ_WHATS_HAPPENING
	dw_const MtMoonShrineJJMetronomeText,        TEXT_MTMOONSHRINE_JJ_METRONOME
	dw_const MtMoonShrineJJDefeatedText,         TEXT_MTMOONSHRINE_JJ_DEFEATED

MtMoonShrineSeymourText:
	text_far _MtMoonShrineSeymourText
	text_end

MtMoonShrineClefairyText:
	text_far _ClefairyText
	text_end

MtMoonShrineJJMoonStoneText:
	text_far _MtMoonShrineJJMoonStoneText
	text_end

MtMoonShrineJJFearNotText:
	text_far _MtMoonShrineJJFearNotText
	text_end

MtMoonShrineJJSpeechText:
	text_far _JJSpeechText
	text_end

MtMoonShrineJJMeowthText:
	text_far _JJMeowthText
	text_end

MtMoonShrineJJBattleText:
	text_asm

	; Start battle
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	call Delay3
	ld a, OPP_JESSIEJAMES
	ld [wCurOpponent], a
	ld a, 3
	ld [wTrainerNo], a

	; Change map script
	ld a, SCRIPT_MTMOONSHRINE_JJ_POST_BATTLE
	ld [wMtMoonShrineCurScript], a
	ld [wCurMapScript], a

	ld hl, MtMoonShrineJJBattleLostText
	ld de, MtMoonShrineJJBattleWonText
	call SaveEndBattleTextPointers

	ld hl, MtMoonShrineJJStartBattleText
	call PrintText
	jp TextScriptEnd

MtMoonShrineJJStartBattleText:
	text_far _MtMoonShrineJJStartBattleText
	text_end

MtMoonShrineJJBattleLostText:
	text_far _MtMoonShrineJJBattleLostText
	text_end

MtMoonShrineJJBattleWonText:
	text_far _JJBattleWonText
	text_end

MtMoonShrineJJWhatsHappeningText:
	text_far _MtMoonShrineJJWhatsHappeningText
	text_end

MtMoonShrineJJMetronomeText:
	text_far _MtMoonShrineJJMetronomeText
	text_end

MtMoonShrineJJDefeatedText:
	text_far _MtMoonShrineJJDefeatedText
	text_end