MtMoonB2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonB2FTrainerHeaders
	ld de, MtMoonB2F_ScriptPointers
	ld a, [wMtMoonB2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoonB2FCurScript], a
	ret

MtMoonB2F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_MTMOONB2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_MTMOONB2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_MTMOONB2F_END_BATTLE

MtMoonB2F_TextPointers:
	def_text_pointers
	dw_const MtMoonB2FRocket1Text,                  TEXT_MTMOONB2F_ROCKET1
	dw_const MtMoonB2FRocket2Text,                  TEXT_MTMOONB2F_ROCKET2
	dw_const MtMoonB2FRocket3Text,                  TEXT_MTMOONB2F_ROCKET3
	dw_const PickUpItemText,                        TEXT_MTMOONB2F_HP_UP
	dw_const PickUpItemText,                        TEXT_MTMOONB2F_TM_MEGA_PUNCH

MtMoonB2FTrainerHeaders:
	def_trainers 3
MtMoonB2FTrainerHeader0:
	trainer EVENT_MT_MOON_B2_BEAT_TRAINER_0, 4, MtMoonB2FRocket1BattleText, MtMoonB2FRocket1EndBattleText, MtMoonB2FRocket1AfterBattleText
MtMoonB2FTrainerHeader1:
	trainer EVENT_MT_MOON_B2_BEAT_TRAINER_1, 4, MtMoonB2FRocket2BattleText, MtMoonB2FRocket2EndBattleText, MtMoonB2FRocket2AfterBattleText
MtMoonB2FTrainerHeader2:
	trainer EVENT_MT_MOON_B2_BEAT_TRAINER_2, 4, MtMoonB2FRocket3BattleText, MtMoonB2FRocket3EndBattleText, MtMoonB2FRocket3AfterBattleText
	db -1 ; end

MtMoonB2FRocket1Text:
	text_asm
	ld hl, MtMoonB2FTrainerHeader0
	jr MtMoonB2FTalkToTrainer

MtMoonB2FRocket2Text:
	text_asm
	ld hl, MtMoonB2FTrainerHeader1
	jr MtMoonB2FTalkToTrainer

MtMoonB2FRocket3Text:
	text_asm
	ld hl, MtMoonB2FTrainerHeader2
	jr MtMoonB2FTalkToTrainer

MtMoonB2FTalkToTrainer:
	call TalkToTrainer
	jp TextScriptEnd

MtMoonB2FRocket1BattleText:
	text_far _MtMoonB2FRocket1BattleText
	text_end

MtMoonB2FRocket1EndBattleText:
	text_far _MtMoonB2FRocket1EndBattleText
	text_end

MtMoonB2FRocket1AfterBattleText:
	text_far _MtMoonB2FRocket1AfterBattleText
	text_end

MtMoonB2FRocket2BattleText:
	text_far _MtMoonB2FRocket2BattleText
	text_end

MtMoonB2FRocket2EndBattleText:
	text_far _MtMoonB2FRocket2EndBattleText
	text_end

MtMoonB2FRocket2AfterBattleText:
	text_far _MtMoonB2FRocket2AfterBattleText
	text_end

MtMoonB2FRocket3BattleText:
	text_far _MtMoonB2FRocket3BattleText
	text_end

MtMoonB2FRocket3EndBattleText:
	text_far _MtMoonB2FRocket3EndBattleText
	text_end

MtMoonB2FRocket3AfterBattleText:
	text_far _MtMoonB2FRocket3AfterBattleText
	text_end
