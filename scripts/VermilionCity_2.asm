VermilionCityPrintGambler1Text::
	CheckEvent EVENT_VERMILION_DOCK_SS_ANNE_LEFT
	jr nz, .ship_departed
	ld hl, VermilionCityGambler1DidYouSeeText
	call PrintText
	ret
.ship_departed
	ld hl, VermilionCityGambler1SSAnneDepartedText
	call PrintText
	ret

VermilionCityGambler1DidYouSeeText:
	text_far _VermilionCityGambler1DidYouSeeText
	text_end

VermilionCityGambler1SSAnneDepartedText:
	text_far _VermilionCityGambler1SSAnneDepartedText
	text_end

VermilionCityPrintSailor1Text::
	CheckEvent EVENT_VERMILION_DOCK_SS_ANNE_LEFT
	jr nz, .ship_departed
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	jr z, .greet_player
	ld hl, VermilionCityInFrontOfOrBehindGuardCoords
	call ArePlayerCoordsInArray
	jr nc, .greet_player_and_check_ticket
.greet_player
	ld hl, VermilionCitySailor1WelcomeToSSAnneText
	call PrintText
	jr .end
.greet_player_and_check_ticket
	ld hl, VermilionCitySailor1DoYouHaveATicketText
	call PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .player_has_ticket
	ld hl, VermilionCitySailor1YouNeedATicketText
	call PrintText
	jr .end
.player_has_ticket
	ld hl, VermilionCitySailor1FlashedTicketText
	call PrintText
	ld a, SCRIPT_VERMILIONCITY_PLAYER_ALLOWED_TO_PASS
	ld [wVermilionCityCurScript], a
	jr .end
.ship_departed
	ld hl, VermilionCitySailor1ShipSetSailText
	call PrintText
.end
	jp TextScriptEnd

VermilionCityInFrontOfOrBehindGuardCoords:
	dbmapcoord 19, 29 ; in front of guard
	dbmapcoord 19, 31 ; behind guard
	db -1 ; end

VermilionCitySailor1WelcomeToSSAnneText:
	text_far _VermilionCitySailor1WelcomeToSSAnneText
	text_end

VermilionCitySailor1DoYouHaveATicketText:
	text_far _VermilionCitySailor1DoYouHaveATicketText
	text_end

VermilionCitySailor1FlashedTicketText:
	text_far _VermilionCitySailor1FlashedTicketText
	text_end

VermilionCitySailor1YouNeedATicketText:
	text_far _VermilionCitySailor1YouNeedATicketText
	text_end

VermilionCitySailor1ShipSetSailText:
	text_far _VermilionCitySailor1ShipSetSailText
	text_end

VermilionCityPrintOfficerJennyText::
	CheckEvent EVENT_VERMILION_GOT_SQUIRTLE
	jr nz, .asm_f1a69

	ld a, [wBeatGymFlags]
	bit BIT_THUNDERBADGE, a
	jr nz, .asm_f1a24
	ld hl, VermilionCityJennyIntroText
	call PrintText
	ret

.asm_f1a24
	ld hl, VermilionCityJennyDoYouWantItText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_f1a62
	ld a, SQUIRTLE
	ld [wNamedObjectIndex], a
	ld [wCurPartySpecies], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	lb bc, SQUIRTLE, 15
	call GivePokemon
	ret nc
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, VermilionCityJennyTakeCareText
	call PrintText
	SetEvent EVENT_VERMILION_GOT_SQUIRTLE
	ret

.asm_f1a62
	ld hl, VermilionCityJennyWhatToDoText
	call PrintText
	ret

.asm_f1a69
	ld hl, VermilionCityJennyHowIsItGoingText
	call PrintText
	ret

VermilionCityJennyIntroText:
	text_far _VermilionCityJennyIntroText
	text_end

VermilionCityJennyDoYouWantItText:
	text_far _VermilionCityJennyDoYouWantItText
	text_end

VermilionCityJennyTakeCareText:
	text_far _VermilionCityJennyTakeCareText
	text_end

VermilionCityJennyWhatToDoText:
	text_far _VermilionCityJennyWhatToDoText
	text_end

VermilionCityJennyHowIsItGoingText:
	text_far _VermilionCityJennyHowIsItGoingText
	text_end
