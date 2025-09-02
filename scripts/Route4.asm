Route4_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route4TrainerHeaders
	ld de, Route4_ScriptPointers
	ld a, [wRoute4CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute4CurScript], a
	ret

Route4_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE4_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE4_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE4_END_BATTLE
	dw_const Route4SeymourEntersCaveScript,         SCRIPT_ROUTE4_SEYMOUR_ENTERS_CAVE
	dw_const Route4SeymourDisappearsScript,         SCRIPT_ROUTE4_SEYMOUR_DISAPPEARS

Route4SeymourMovement:
	db NPC_MOVEMENT_UP
	db -1 ; end

Route4SeymourEntersCaveScript:
	; Block input
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Move object upwards
	ld a, ROUTE4_SEYMOUR
	ldh [hSpriteIndex], a
	ld de, Route4SeymourMovement
	call MoveSprite

	ld a, SCRIPT_ROUTE4_SEYMOUR_DISAPPEARS
	ld [wRoute4CurScript], a
	ld [wCurMapScript], a
	ret

Route4SeymourDisappearsScript:
	; Wait for movement to finish
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Hide him
	ld a, HS_ROUTE_4_SEYMOUR
	ld [wMissableObjectIndex], a
	predef HideObject

	; Renable input
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_ROUTE4_DEFAULT
	ld [wRoute4CurScript], a
	ld [wCurMapScript], a
	ret

Route4_TextPointers:
	def_text_pointers
	dw_const Route4CooltrainerF1Text, TEXT_ROUTE4_COOLTRAINER_F1
	dw_const Route4CooltrainerF2Text, TEXT_ROUTE4_COOLTRAINER_F2
	dw_const PickUpItemText,          TEXT_ROUTE4_TM_RAZOR_WIND
	dw_const Route4SeymourText,       TEXT_ROUTE4_SEYMOUR
	dw_const Route4ZubatText,         TEXT_ROUTE4_ZUBAT
	dw_const PokeCenterSignText,      TEXT_ROUTE4_POKECENTER_SIGN
	dw_const Route4MtMoonSignText,    TEXT_ROUTE4_MT_MOON_SIGN
	dw_const Route4SignText,          TEXT_ROUTE4_SIGN

Route4TrainerHeaders:
	def_trainers 2
Route4TrainerHeader0:
	trainer EVENT_ROUTE_4_BEAT_TRAINER_0, 3, Route4CooltrainerF2BattleText, Route4CooltrainerF2EndBattleText, Route4CooltrainerF2AfterBattleText
ZubatTrainerHeader:
	trainer EVENT_ROUTE_4_BEAT_ZUBAT, 0, Route4ZubatBattleText, Route4ZubatBattleText, Route4ZubatBattleText
	db -1 ; end

Route4CooltrainerF1Text:
	text_far _Route4CooltrainerF1Text
	text_end

Route4CooltrainerF2Text:
	text_asm
	ld hl, Route4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route4CooltrainerF2BattleText:
	text_far _Route4CooltrainerF2BattleText
	text_end

Route4CooltrainerF2EndBattleText:
	text_far _Route4CooltrainerF2EndBattleText
	text_end

Route4CooltrainerF2AfterBattleText:
	text_far _Route4CooltrainerF2AfterBattleText
	text_end

Route4SeymourText:
	text_asm
	callfar Route4PrintSeymourText
	jp TextScriptEnd

Route4ZubatText:
	text_asm
	ld hl, ZubatTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

Route4ZubatBattleText:
	text_asm
	ld hl, Route4ZubatPrintBattleText
	call PrintText
	ld a, ZUBAT
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

Route4ZubatPrintBattleText:
	text_far _Route4ZubatBattleText
	text_end

Route4MtMoonSignText:
	text_far _Route4MtMoonSignText
	text_end

Route4SignText:
	text_far _Route4SignText
	text_end
