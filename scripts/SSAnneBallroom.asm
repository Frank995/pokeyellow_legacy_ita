SSAnneBallroom_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSAnneBallroomTrainerHeaders
	ld de, SSAnneBallroom_ScriptPointers
	ld a, [wSSAnneBallroomCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSAnneBallroomCurScript], a
	ret

SSAnneBallroom_ScriptPointers:
	def_script_pointers
	dw_const SSAnneBallroomRocketIntroScript,       SCRIPT_SSANNEBALLROOM_ROCKET_INTRO
	dw_const SSAnneBallroomRocketGreetingsScript,   SCRIPT_SSANNEBALLROOM_ROCKET_GREETINGS
	dw_const SSAnneBallroomRocketBlackoutScript,    SCRIPT_SSANNEBALLROOM_ROCKET_BLACKOUT
	dw_const CheckFightingMapTrainers,              SCRIPT_SSANNEBALLROOM_CHECK_TRAINERS
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSANNEBALLROOM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSANNEBALLROOM_END_BATTLE

SSAnneBallroomRocketIntroScript:
	CheckEvent EVENT_SS_ANNE_ROCKET_APPEARED
	jr nz, .skip

	; Block input
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	; Move player down 3 tiles immediately after text ends
	ld a, 3  
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd+1], a
	ld [wSimulatedJoypadStatesEnd+2], a
	call StartSimulatingJoypadStates

	ld a, SCRIPT_SSANNEBALLROOM_ROCKET_GREETINGS
	ld [wSSAnneBallroomCurScript], a
	ld [wCurMapScript], a
	ret
.skip
	ld a, SCRIPT_SSANNEBALLROOM_CHECK_TRAINERS
	ld [wSSAnneBallroomCurScript], a
	ld [wCurMapScript], a
	ret

SSAnneBallroomRocketGreetingsScript:
	; Wait for movement
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	
	SetEvent EVENT_SS_ANNE_ROCKET_APPEARED
	ld a, TEXT_SSANNEBALLROOM_INTRO
	ldh [hTextID], a
	call DisplayTextID

	ld a, SCRIPT_SSANNEBALLROOM_ROCKET_BLACKOUT
	ld [wSSAnneBallroomCurScript], a
	ld [wCurMapScript], a
	ret

SSAnneBallroomRocketBlackoutScript:
	; Wait a little
	ld c, 20
	call DelayFrames

	; Black out
	call GBFadeOutToBlack

	; Waiting a little
	ld c, 80 
	call DelayFrames

	; Show NPCs
	ld a, HS_SS_ANNE_BALLROOM_ROCKET
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_SS_ANNE_CAPTAINS_ROOM_JESSIE
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_SS_ANNE_CAPTAINS_ROOM_JAMES
	ld [wMissableObjectIndex], a
	predef ShowObject

	; Play music
	ld c, BANK(Music_MeetEvilTrainer)
	ld a, MUSIC_MEET_EVIL_TRAINER
	call PlayMusic

	; Additional delay
	ld c, 10
	call DelayFrames

	; Fade in
	call GBFadeInFromBlack

	ld a, SCRIPT_SSANNEBALLROOM_CHECK_TRAINERS
	ld [wSSAnneBallroomCurScript], a
	ld [wCurMapScript], a
	ret

SSAnneBallroom_TextPointers:
	def_text_pointers
	dw_const SSAnneBallroomRocket1Text, TEXT_SSANNEBALLROOM_ROCKET1
	dw_const SSAnneBallroomRocket2Text, TEXT_SSANNEBALLROOM_ROCKET2
	dw_const SSAnneBallroomRocket3Text, TEXT_SSANNEBALLROOM_ROCKET3
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_SAILOR
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_GENTLEMAN1
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_BEUTY1
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_COOLTRAINER_F1
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_COOLTRAINER_M1
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_GENTLEMAN2
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_BEUTY2
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_COOLTRAINER_F2
	dw_const SSAnneBallroomSilentText,  TEXT_SSANNEBALLROOM_COOLTRAINER_M2
	dw_const SSAnneBallroomIntroText,   TEXT_SSANNEBALLROOM_INTRO

SSAnneBallroomTrainerHeaders:
	def_trainers
SSAnneBallroomTrainerHeader0:
	trainer EVENT_SS_ANNE_BALLROOM_BEAT_TRAINER_0, 4, SSAnneBallroomRocket1BattleText, SSAnneBallroomRocket1EndBattleText, SSAnneBallroomRocket1AfterBattleText
SSAnneBallroomTrainerHeader1:
	trainer EVENT_SS_ANNE_BALLROOM_BEAT_TRAINER_1, 2, SSAnneBallroomRocket2BattleText, SSAnneBallroomRocket2EndBattleText, SSAnneBallroomRocket2AfterBattleText
SSAnneBallroomTrainerHeader2:
	trainer EVENT_SS_ANNE_BALLROOM_BEAT_TRAINER_2, 2, SSAnneBallroomRocket3BattleText, SSAnneBallroomRocket3EndBattleText, SSAnneBallroomRocket3AfterBattleText
	db -1 ; end

SSAnneBallroomSilentText:
	text_far _SSAnneBallroomSilentText
	text_end

SSAnneBallroomIntroText:
	text_far _SSAnneBallroomIntroText
	text_end

SSAnneBallroomRocket1Text:
	text_asm
	ld hl, SSAnneBallroomTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSAnneBallroomRocket2Text:
	text_asm
	ld hl, SSAnneBallroomTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSAnneBallroomRocket3Text:
	text_asm
	ld hl, SSAnneBallroomTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSAnneBallroomRocket1BattleText::
	text_far _SSAnneBallroomRocket1BattleText
	text_end

SSAnneBallroomRocket1EndBattleText::
	text_far _SSAnneBallroomRocket1EndBattleText
	text_end

SSAnneBallroomRocket1AfterBattleText::
	text_far _SSAnneBallroomRocket1AfterBattleText
	text_end

SSAnneBallroomRocket2BattleText::
	text_far _SSAnneBallroomRocket2BattleText
	text_end

SSAnneBallroomRocket2EndBattleText::
	text_far _SSAnneBallroomRocket2EndBattleText
	text_end

SSAnneBallroomRocket2AfterBattleText::
	text_far _SSAnneBallroomRocket2AfterBattleText
	text_end

SSAnneBallroomRocket3BattleText::
	text_far _SSAnneBallroomRocket3BattleText
	text_end

SSAnneBallroomRocket3EndBattleText::
	text_far _SSAnneBallroomRocket3EndBattleText
	text_end

SSAnneBallroomRocket3AfterBattleText::
	text_far _SSAnneBallroomRocket3AfterBattleText
	text_end
