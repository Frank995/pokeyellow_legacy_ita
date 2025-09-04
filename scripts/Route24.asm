Route24_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route24TrainerHeaders
	ld de, Route24_ScriptPointers
	ld a, [wRoute24CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute24CurScript], a
	ret

Route24_ScriptPointers:
	def_script_pointers
	dw_const Route24DefaultScript,                  SCRIPT_ROUTE24_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE24_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE24_END_BATTLE
	dw_const Route24AfterRocketBattleScript,        SCRIPT_ROUTE24_AFTER_ROCKET_BATTLE
	dw_const Route24PlayerMovingScript,             SCRIPT_ROUTE24_PLAYER_MOVING

Route24DefaultScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC

	; If already got nugger skip
	CheckEvent EVENT_ROUTE_24_GOT_NUGGET
	jp nz, CheckFightingMapTrainers

	; Skip if not in front of rocket
	ld hl, Route24RocketCoordsArray
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers

	; Block input and turn player
	xor a
	ldh [hJoyHeld], a
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a

	; Display text
	ld a, TEXT_ROUTE24_ROCKET
	ldh [hTextID], a
	call DisplayTextID

	; If nugget is not available for some reason, go back
	CheckAndResetEvent EVENT_ROUTE_24_NUGGET_REWARD_AVAILABLE
	ret z
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates

	ld a, SCRIPT_ROUTE24_PLAYER_MOVING
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	ret

Route24RocketCoordsArray:
	dbmapcoord 10, 15
	db -1 ; end

Route24PlayerMovingScript:
	; Wait for player finishing movement
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3

	ld a, SCRIPT_ROUTE24_DEFAULT
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	ret

Route24AfterRocketBattleScript:
	; Check if player lost
	ld a, [wIsInBattle]
	inc a
	jr z, .skip

	SetEvent EVENT_ROUTE_24_BEAT_ROCKET
.skip
	xor a ; SCRIPT_ROUTE24_DEFAULT
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	ret

Route24_TextPointers:
	def_text_pointers
	dw_const Route24RocketText,        TEXT_ROUTE24_ROCKET
	dw_const Route24CooltrainerM1Text, TEXT_ROUTE24_COOLTRAINER_M1
	dw_const Route24CooltrainerM2Text, TEXT_ROUTE24_COOLTRAINER_M2
	dw_const Route24CooltrainerF1Text, TEXT_ROUTE24_COOLTRAINER_F1
	dw_const Route24Youngster1Text,    TEXT_ROUTE24_YOUNGSTER1
	dw_const Route24CooltrainerF2Text, TEXT_ROUTE24_COOLTRAINER_F2
	dw_const Route24Youngster2Text,    TEXT_ROUTE24_YOUNGSTER2
	dw_const PickUpItemText,           TEXT_ROUTE24_TM_THUNDER_WAVE
	dw_const Route24DamianText,        TEXT_ROUTE24_DAMIAN

Route24TrainerHeaders:
	def_trainers 2
Route24TrainerHeader0:
	trainer EVENT_ROUTE_24_BEAT_TRAINER_0, 4, Route24CooltrainerM1BattleText, Route24CooltrainerM1EndBattleText, Route24CooltrainerM1AfterBattleText
Route24TrainerHeader1:
	trainer EVENT_ROUTE_24_BEAT_TRAINER_1, 1, Route24CooltrainerM2BattleText, Route24CooltrainerM2EndBattleText, Route24CooltrainerM2AfterBattleText
Route24TrainerHeader2:
	trainer EVENT_ROUTE_24_BEAT_TRAINER_2, 1, Route24CooltrainerF1BattleText, Route24CooltrainerF1EndBattleText, Route24CooltrainerF1AfterBattleText
Route24TrainerHeader3:
	trainer EVENT_ROUTE_24_BEAT_TRAINER_3, 1, Route24Youngster1BattleText, Route24Youngster1EndBattleText, Route24Youngster1AfterBattleText
Route24TrainerHeader4:
	trainer EVENT_ROUTE_24_BEAT_TRAINER_4, 1, Route24CooltrainerF2BattleText, Route24CooltrainerF2EndBattleText, Route24CooltrainerF2AfterBattleText
Route24TrainerHeader5:
	trainer EVENT_ROUTE_24_BEAT_TRAINER_5, 1, Route24Youngster2BattleText, Route24Youngster2EndBattleText, Route24Youngster2AfterBattleText
	db -1 ; end

Route24RocketText:
	text_asm
	callfar Route24PrintRocketText
	jp TextScriptEnd

Route24CooltrainerM1Text:
	text_asm
	ld hl, Route24TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route24CooltrainerM2Text:
	text_asm
	ld hl, Route24TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route24CooltrainerF1Text:
	text_asm
	ld hl, Route24TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route24Youngster1Text:
	text_asm
	ld hl, Route24TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route24CooltrainerF2Text:
	text_asm
	ld hl, Route24TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route24Youngster2Text:
	text_asm
	ld hl, Route24TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route24CooltrainerM1BattleText:
	text_far _Route24CooltrainerM1BattleText
	text_end

Route24CooltrainerM1EndBattleText:
	text_far _Route24CooltrainerM1EndBattleText
	text_end

Route24CooltrainerM1AfterBattleText:
	text_far _Route24CooltrainerM1AfterBattleText
	text_end

Route24CooltrainerM2BattleText:
	text_far _Route24CooltrainerM2BattleText
	text_end

Route24CooltrainerM2EndBattleText:
	text_far _Route24CooltrainerM2EndBattleText
	text_end

Route24CooltrainerM2AfterBattleText:
	text_far _Route24CooltrainerM2AfterBattleText
	text_end

Route24CooltrainerF1BattleText:
	text_far _Route24CooltrainerF1BattleText
	text_end

Route24CooltrainerF1EndBattleText:
	text_far _Route24CooltrainerF1EndBattleText
	text_end

Route24CooltrainerF1AfterBattleText:
	text_far _Route24CooltrainerF1AfterBattleText
	text_end

Route24Youngster1BattleText:
	text_far _Route24Youngster1BattleText
	text_end

Route24Youngster1EndBattleText:
	text_far _Route24Youngster1EndBattleText
	text_end

Route24Youngster1AfterBattleText:
	text_far _Route24Youngster1AfterBattleText
	text_end

Route24CooltrainerF2BattleText:
	text_far _Route24CooltrainerF2BattleText
	text_end

Route24CooltrainerF2EndBattleText:
	text_far _Route24CooltrainerF2EndBattleText
	text_end

Route24CooltrainerF2AfterBattleText:
	text_far _Route24CooltrainerF2AfterBattleText
	text_end

Route24Youngster2BattleText:
	text_far _Route24Youngster2BattleText
	text_end

Route24Youngster2EndBattleText:
	text_far _Route24Youngster2EndBattleText
	text_end

Route24Youngster2AfterBattleText:
	text_far _Route24Youngster2AfterBattleText
	text_end

Route24DamianText:
	text_asm
	callfar Route24PrintDamianText
	jp TextScriptEnd