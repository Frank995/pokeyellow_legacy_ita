VermilionCity_Script:
	; Reset the cans
	ResetEvent EVENT_VERMILION_GYM_1ST_LOCK_OPENED
	call Random
	and $e
	ld [wFirstLockTrashCanIndex], a

	call EnableAutoTextBoxDrawing
	ld hl, wd492
	res 7, [hl]
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	push hl
	call nz, VermilionCityLeftSSAnneCallbackScript
	pop hl
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	call nz, .setFirstLockTrashCanIndex
	ld hl, VermilionCity_ScriptPointers
	ld a, [wVermilionCityCurScript]
	call CallFunctionInTable

	CheckEventHL EVENT_VERMILION_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	ret nz
	CheckEventReuseHL EVENT_VERMILION_GOT_BIKE_VOUCHER
	ret z
	SetEventReuseHL EVENT_VERMILION_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	ret

.setFirstLockTrashCanIndex
	call Random
	ldh a, [hRandomAdd]
	ld b, a
	ldh a, [hRandomSub]
	adc b
	and $e
	ld [wFirstLockTrashCanIndex], a
	ret

VermilionCityLeftSSAnneCallbackScript:
	CheckEventHL EVENT_VERMILION_DOCK_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_VERMILION_DOCK_WALKED_OUT_PAST_GUARD
	SetEventReuseHL EVENT_VERMILION_DOCK_WALKED_OUT_PAST_GUARD
	ret nz
	ld a, SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP
	ld [wVermilionCityCurScript], a
	ld [wCurMapScript], a
	ret

VermilionCity_ScriptPointers:
	def_script_pointers
	dw_const VermilionCityDefaultScript,             SCRIPT_VERMILIONCITY_DEFAULT
	dw_const VermilionCityPlayerMovingUp1Script,     SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP1
	dw_const VermilionCityPlayerExitShipScript,      SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP
	dw_const VermilionCityPlayerMovingUp2Script,     SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP2
	dw_const VermilionCityPlayerAllowedToPassScript, SCRIPT_VERMILIONCITY_PLAYER_ALLOWED_TO_PASS

VermilionCityTicketCheckCoords:
	dbmapcoord 18, 30
	db -1 ; end

VermilionCityDefaultScript:
	; Check if player is heading down
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ret nz

	; Check is player is at the entrance
	ld hl, VermilionCityTicketCheckCoords
	call ArePlayerCoordsInArray
	ret nc

	; Block player
	xor a
	ldh [hJoyHeld], a

	; Print text
	ld a, TEXT_VERMILIONCITY_SAILOR1
	ldh [hTextID], a
	call DisplayTextID

	; Check if ship has left
	CheckEvent EVENT_VERMILION_DOCK_SS_ANNE_LEFT
	jr nz, .ship_departed

	; If player has ticket returns
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.ship_departed
	; Player moves up
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates

	ld a, SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP1
	ld [wVermilionCityCurScript], a
	ld [wCurMapScript], a
	ret

VermilionCityPlayerMovingUp1Script:
	; Wait till movement finishes
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz

	ld c, 10
	call DelayFrames
	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ld [wCurMapScript], a
	ret

VermilionCityPlayerExitShipScript:
	; Block input and move player up
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates

	ld a, SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP2
	ld [wVermilionCityCurScript], a
	ld [wCurMapScript], a
	ret

VermilionCityPlayerMovingUp2Script:
	; Wait for movement to finish and reenable input
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ldh [hJoyHeld], a

	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ld [wCurMapScript], a
	ret

VermilionCityPlayerAllowedToPassScript:
	ld hl, VermilionCityTicketCheckCoords
	call ArePlayerCoordsInArray
	ret c

	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ld [wCurMapScript], a
	ret


VermilionCity_TextPointers:
	def_text_pointers
	dw_const VermilionCityBeautyText,             TEXT_VERMILIONCITY_BEAUTY
	dw_const VermilionCityGambler1Text,           TEXT_VERMILIONCITY_GAMBLER1
	dw_const VermilionCitySailor1Text,            TEXT_VERMILIONCITY_SAILOR1
	dw_const VermilionCityGambler2Text,           TEXT_VERMILIONCITY_GAMBLER2
	dw_const VermilionCityMachopText,             TEXT_VERMILIONCITY_MACHOP
	dw_const VermilionCitySailor2Text,            TEXT_VERMILIONCITY_SAILOR2
	dw_const VermilionCityOfficerJennyText,       TEXT_VERMILIONCITY_OFFICER_JENNY
	dw_const VermilionCitySignText,               TEXT_VERMILIONCITY_SIGN
	dw_const VermilionCityNoticeSignText,         TEXT_VERMILIONCITY_NOTICE_SIGN
	dw_const MartSignText,                        TEXT_VERMILIONCITY_MART_SIGN
	dw_const PokeCenterSignText,                  TEXT_VERMILIONCITY_POKECENTER_SIGN
	dw_const VermilionCityPokemonFanClubSignText, TEXT_VERMILIONCITY_POKEMON_FAN_CLUB_SIGN
	dw_const VermilionCityGymSignText,            TEXT_VERMILIONCITY_GYM_SIGN
	dw_const VermilionCityHarborSignText,         TEXT_VERMILIONCITY_HARBOR_SIGN

VermilionCityBeautyText:
	text_far _VermilionCityBeautyText
	text_end

VermilionCityGambler1Text:
	text_asm
	farcall VermilionCityPrintGambler1Text
	jp TextScriptEnd

VermilionCitySailor1Text:
	text_asm
	farcall VermilionCityPrintSailor1Text
	jp TextScriptEnd

VermilionCityGambler2Text:
	text_far _VermilionCityGambler2Text
	text_end

VermilionCityMachopText:
	text_asm
	ld hl, VermilionCityPrintMachopText
	call PrintText
	ld a, MACHOP
	call PlayCry
	call WaitForSoundToFinish
	ld hl, VermilionCityMachopStompingText
	call PrintText
	jp TextScriptEnd

VermilionCityPrintMachopText:
	text_far _VermilionCityMachopText
	text_end

VermilionCityMachopStompingText:
	text_far _VermilionCityMachopStompingText
	text_end

VermilionCitySailor2Text:
	text_far _VermilionCitySailor2Text
	text_end

VermilionCitySignText:
	text_far _VermilionCitySignText
	text_end

VermilionCityNoticeSignText:
	text_far _VermilionCityNoticeSignText
	text_end

VermilionCityPokemonFanClubSignText:
	text_far _VermilionCityPokemonFanClubSignText
	text_end

VermilionCityGymSignText:
	text_far _VermilionCityGymSignText
	text_end

VermilionCityHarborSignText:
	text_far _VermilionCityHarborSignText
	text_end

VermilionCityOfficerJennyText:
	text_asm
	farcall VermilionCityPrintOfficerJennyText
	jp TextScriptEnd
