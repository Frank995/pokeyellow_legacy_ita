ViridianCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianCity_ScriptPointers
	ld a, [wViridianCityCurScript]
	jp CallFunctionInTable

ViridianCity_ScriptPointers:
	def_script_pointers
	dw_const ViridianCityGymCheckScript,            SCRIPT_VIRIDIANCITY_GYM_CHECK
	dw_const ViridianCityGymMoveDownScript,         SCRIPT_VIRIDIANCITY_GYM_MOVE_DOWN
	dw_const ViridianCityGymPlayerMovingDownScript, SCRIPT_VIRIDIANCITY_GYM_PLAYER_MOVING_DOWN
	dw_const ViridianCityNoopScript,                SCRIPT_VIRIDIANCITY_NOOP

ViridianCityGymCheckScript:
	; Check if gym is already open
	CheckEvent EVENT_VIRIDIAN_GYM_OPEN
	jr nz, .gymOpen
	
	; Check if player has enough badges
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	jr nz, .checkGymEntrance
	
	; Open gym and switch to noop
	SetEvent EVENT_VIRIDIAN_GYM_OPEN
	ld a, SCRIPT_VIRIDIANCITY_NOOP
	ld [wViridianCityCurScript], a
	ld [wCurMapScript], a
	ret
.gymOpen
	; Gym is open, use noop script
	ld a, SCRIPT_VIRIDIANCITY_NOOP
	ld [wViridianCityCurScript], a
	ld [wCurMapScript], a
	ret
.checkGymEntrance
	; Check if player is at gym entrance
	ld a, [wYCoord]
	cp 8
	ret nz
	ld a, [wXCoord]
	cp 32
	ret nz

	; Stop player movement
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	; Trigger lock message + move down state
	ld a, SCRIPT_VIRIDIANCITY_GYM_MOVE_DOWN
	ld [wViridianCityCurScript], a
	ld [wCurMapScript], a
	ret

ViridianCityGymMoveDownScript:
	; Display gym locked message
	ld a, TEXT_VIRIDIANCITY_GYM_LOCKED
	ldh [hTextID], a
	call DisplayTextID

	; Set up simulated movement
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a ; keep Pikachu in sync
	call StartSimulatingJoypadStates

	; Switch to moving-down script
	ld a, SCRIPT_VIRIDIANCITY_GYM_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	ld [wCurMapScript], a
	ret

ViridianCityGymPlayerMovingDownScript:
	; Wait until simulated movement is done
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz

	; Optional small delay (prevents weird mid-frame sync issues)
	call Delay3

	; Reenable input
	xor a
	ld [wJoyIgnore], a

	; Go back to normal gym check
	ld a, SCRIPT_VIRIDIANCITY_GYM_CHECK
	ld [wViridianCityCurScript], a
	ld [wCurMapScript], a
	ret

ViridianCityNoopScript:
	ret

ViridianCity_TextPointers:
	def_text_pointers
	dw_const ViridianCityYoungster1Text,   TEXT_VIRIDIANCITY_YOUNGSTER1
	dw_const ViridianCityGambler1Text,     TEXT_VIRIDIANCITY_GAMBLER1
	dw_const ViridianCityYoungster2Text,   TEXT_VIRIDIANCITY_YOUNGSTER2
	dw_const ViridianCityGirlText,         TEXT_VIRIDIANCITY_GIRL
	dw_const ViridianCityOldManSleepyText, TEXT_VIRIDIANCITY_OLD_MAN_SLEEPY
	dw_const ViridianCityFisherText,       TEXT_VIRIDIANCITY_FISHER
	dw_const ViridianCityOldManText,       TEXT_VIRIDIANCITY_OLD_MAN
	dw_const ViridianCitySignText,         TEXT_VIRIDIANCITY_SIGN
	dw_const ViridianCityTrainerTips1Text, TEXT_VIRIDIANCITY_TRAINER_TIPS1
	dw_const ViridianCityTrainerTips2Text, TEXT_VIRIDIANCITY_TRAINER_TIPS2
	dw_const MartSignText,                 TEXT_VIRIDIANCITY_MART_SIGN
	dw_const PokeCenterSignText,           TEXT_VIRIDIANCITY_POKECENTER_SIGN
	dw_const ViridianCityGymSignText,      TEXT_VIRIDIANCITY_GYM_SIGN
	dw_const ViridianCityGymLockedText,    TEXT_VIRIDIANCITY_GYM_LOCKED

ViridianCityYoungster1Text:
	text_far _ViridianCityYoungster1Text
	text_end

ViridianCityGambler1Text:
	text_asm
	farcall ViridianCityPrintGambler1Text
	jp TextScriptEnd

ViridianCityYoungster2Text:
	text_asm
	farcall ViridianCityPrintYoungster2Text
	jp TextScriptEnd

ViridianCityGirlText:
	text_asm
	farcall ViridianCityPrintGirlText
	jp TextScriptEnd

ViridianCityOldManSleepyText:
	text_far _ViridianCityOldManSleepyText
	text_end

ViridianCityFisherText:
	text_asm
	farcall ViridianCityPrintFisherText
	jp TextScriptEnd

ViridianCityOldManText:
	text_far _ViridianCityOldManText
	text_end

ViridianCitySignText:
	text_far _ViridianCitySignText
	text_end

ViridianCityTrainerTips1Text:
	text_far _ViridianCityTrainerTips1Text
	text_end

ViridianCityTrainerTips2Text:
	text_far _ViridianCityTrainerTips2Text
	text_end

ViridianCityGymSignText:
	text_far _ViridianCityGymSignText
	text_end

ViridianCityGymLockedText:
	text_far _ViridianCityGymLockedText
	text_end
