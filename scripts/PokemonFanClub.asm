PokemonFanClub_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonFanClub_ScriptPointers
	ld a, [wPokemonFanClubCurScript]
	jp CallFunctionInTable

PokemonFanClub_ScriptPointers:
	def_script_pointers
	dw_const PokemonFanClubScript0, SCRIPT_POKEMONFANCLUB_SCRIPT0
	dw_const PokemonFanClubScript1, SCRIPT_POKEMONFANCLUB_SCRIPT1

PokemonFanClubScript0:
	ld hl, wd492
	bit 7, [hl]
	call z, PokemonFanClubScript_59a44
	ld hl, wd492
	set 7, [hl]
	ret

PokemonFanClubScript1:
	ld hl, wd492
	bit 7, [hl]
	call z, PokemonFanClubScript_59a39
	ld hl, wd492
	set 7, [hl]
	ret

PokemonFanClubScript_59a39:
	call Random
	ldh a, [hRandomAdd]
	cp 25
	call c, PokemonFanClubScript_59a44
	ret

PokemonFanClubScript_59a44:
	ld a, [wd471]
	bit 7, a
	ret z
	callfar CheckPikachuFaintedOrStatused
	ret c
	ld a, SCRIPT_POKEMONFANCLUB_SCRIPT1
	ld [wPokemonFanClubCurScript], a
	xor a
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	call UpdateSprites
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	ld a, $f ; Pikachu
	ld [wEmotionBubbleSpriteIndex], a
	predef EmotionBubble
	ld hl, PokemonFanClubPikachuMovementData
	call ApplyPikachuMovementData
	ld a, $2 ; Seel
	ld [wSprite03StateData1MovementStatus], a
	xor a ; SPRITE_FACING_DOWN
	ld [wSprite03StateData1FacingDirection], a
	callfar InitializePikachuTextID
	call DisablePikachuFollowingPlayer
	ret

PokemonFanClubPikachuMovementData:
	db $00
	db $26
	db $20
	db $20
	db $20
	db $1e
	db $3f

PokemonFanClub_TextPointers:
	def_text_pointers
	dw_const PokemonFanClubClefairyFanText,  TEXT_POKEMONFANCLUB_CLEFAIRY_FAN
	dw_const PokemonFanClubSeelFanText,      TEXT_POKEMONFANCLUB_SEEL_FAN
	dw_const PokemonFanClubClefairyText,     TEXT_POKEMONFANCLUB_CLEFAIRY
	dw_const PokemonFanClubSeelText,         TEXT_POKEMONFANCLUB_SEEL
	dw_const PokemonFanClubChairmanText,     TEXT_POKEMONFANCLUB_CHAIRMAN
	dw_const PokemonFanClubReceptionistText, TEXT_POKEMONFANCLUB_RECEPTIONIST

PokemonFanClubClefairyFanText:
	text_asm
	CheckEventHL EVENT_VERMILION_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	jr z, .first_time
	ld hl, PokemonFanClubPrintClefairyFanText
	call PrintText
	jr .done
.first_time
	CheckEventReuseHL EVENT_VERMILION_PIKACHU_FAN_BOAST
	jr nz, .mineisbetter
	SetEventReuseHL EVENT_VERMILION_SEEL_FAN_BOAST
	ld hl, PokemonFanClubClefairyFanNormalText
	call PrintText
	jr .done
.mineisbetter
	ResetEventReuseHL EVENT_VERMILION_PIKACHU_FAN_BOAST
	ld hl, PokemonFanClubClefairyFanBetterText
	call PrintText
.done
	jp TextScriptEnd

PokemonFanClubClefairyFanNormalText:
	text_far _PokemonFanClubClefairyFanNormalText
	text_end

PokemonFanClubClefairyFanBetterText:
	text_far _PokemonFanClubClefairyFanBetterText
	text_end

PokemonFanClubPrintClefairyFanText:
	text_far _PokemonFanClubClefairyFanText
	text_end

PokemonFanClubSeelFanText:
	text_asm
	CheckEventHL EVENT_VERMILION_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	jr z, .first_time
	ld hl, PokemonFanClubPrintSeelFanText
	call PrintText
	jr .done
.first_time
	CheckEventReuseHL EVENT_VERMILION_SEEL_FAN_BOAST
	jr nz, .mineisbetter
	SetEventReuseHL EVENT_VERMILION_PIKACHU_FAN_BOAST
	ld hl, PokemonFanClubSeelFanNormalText
	call PrintText
	jr .done
.mineisbetter
	ResetEventReuseHL EVENT_VERMILION_SEEL_FAN_BOAST
	ld hl, PokemonFanClubSeelFanBetterText
	call PrintText
.done
	jp TextScriptEnd

PokemonFanClubSeelFanNormalText:
	text_far _PokemonFanClubSeelFanNormalText
	text_end

PokemonFanClubSeelFanBetterText:
	text_far _PokemonFanClubSeelFanBetterText
	text_end

PokemonFanClubPrintSeelFanText:
	text_far _PokemonFanClubSeelFanText
	text_end

PokemonFanClubClefairyText:
	text_asm
	ld hl, PokemonFanClubPrintClefairyText
	call PrintText
	ld a, CLEFAIRY
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

PokemonFanClubPrintClefairyText:
	text_far _PokemonFanClubClefairyText
	text_end

PokemonFanClubSeelText:
	text_asm
	ld hl, PokemonFanClubPrintSeelText
	call PrintText
	ld a, SEEL
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

PokemonFanClubPrintSeelText:
	text_far _PokemonFanClubSeelText
	text_end

PokemonFanClubChairmanText:
	text_asm
	CheckEventHL EVENT_VERMILION_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	jr z, .check_bike_voucher
	ld hl, PokemonFanClubChairmanPrint1Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr z, .select_mon_to_print
	ld hl, PokemonFanClubChairmanPrint2Text
	jr .gbpals_print_text

.check_bike_voucher
	CheckEvent EVENT_VERMILION_GOT_BIKE_VOUCHER
	jr nz, .nothingleft
	ld hl, PokemonFanClubChairmanIntroText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .nothanks

	; tell the story
	ld hl, PokemonFanClubChairmanStoryText
	call PrintText
	lb bc, BIKE_VOUCHER, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, PokemonFanClubReceivedBikeVoucherText
	call PrintText
	SetEvent EVENT_VERMILION_GOT_BIKE_VOUCHER
	jp TextScriptEnd
.bag_full
	ld hl, PokemonFanClubChairmanBagFullText
	jr .gbpals_print_text
.nothanks
	ld hl, PokemonFanClubChairmanNoStoryText
	jr .gbpals_print_text
.nothingleft
	ld hl, PokemonFanClubChairmanFinalText
.gbpals_print_text
	push hl
	call LoadGBPal
	pop hl
	call PrintText
	jp TextScriptEnd

.select_mon_to_print
	call GBPalWhiteOutWithDelay3
	call LoadCurrentMapView
	call SaveScreenTilesToBuffer2
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, $00
	ld [wTempTilesetNumTiles], a
	call DisplayPartyMenu
	jp nc, .print
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	ld hl, PokemonFanClubChairmanPrint2Text
	jr .gbpals_print_text

.print
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	callfar PrintFanClubPortrait
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	ld hl, PokemonFanClubChairmanPrint4Text
	ldh a, [hOaksAideResult]
	and a
	jr nz, .gbpals_print_text
	ld hl, PokemonFanClubChairmanPrint3Text
	jr .gbpals_print_text

PokemonFanClubChairmanIntroText:
	text_far _PokemonFanClubChairmanIntroText
	text_end

PokemonFanClubChairmanStoryText:
	text_far _PokemonFanClubChairmanStoryText
	text_end

PokemonFanClubReceivedBikeVoucherText:
	text_far _PokemonFanClubReceivedBikeVoucherText
	sound_get_key_item
	text_far _PokemonFanClubExplainBikeVoucherText
	text_end

PokemonFanClubChairmanNoStoryText:
	text_far _PokemonFanClubChairmanNoStoryText
	text_end

PokemonFanClubChairmanFinalText:
	text_far _PokemonFanClubChairmanFinalText
	text_end

PokemonFanClubChairmanBagFullText:
	text_far _PokemonFanClubChairmanBagFullText
	text_end

PokemonFanClubChairmanPrint1Text:
	text_far _PokemonFanClubChairmanPrint1Text
	text_end

PokemonFanClubChairmanPrint2Text:
	text_far _PokemonFanClubChairmanPrint2Text
	text_end

PokemonFanClubChairmanPrint3Text:
	text_far _PokemonFanClubChairmanPrint3Text
	text_end

PokemonFanClubChairmanPrint4Text:
	text_far _PokemonFanClubChairmanPrint4Text
	text_end

PokemonFanClubReceptionistText:
	text_far _PokemonFanClubReceptionistText
	text_end
