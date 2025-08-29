CeruleanMelaniesHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

CeruleanMelaniesHouse_TextPointers:
	def_text_pointers
	dw_const CeruleanMelanieHouseMelanieText, TEXT_CERULEANMELANIESHOUSE_MELANIE
	dw_const CeruleanMelanieHouseBulbasaurText, TEXT_CERULEANMELANIESHOUSE_BULBASAUR
	dw_const CeruleanMelanieHouseOddishText, TEXT_CERULEANMELANIESHOUSE_ODDISH
	dw_const CeruleanMelanieHouseSandshrewText, TEXT_CERULEANMELANIESHOUSE_SANDSHREW

CeruleanMelanieHouseMelanieText:
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	CheckEvent EVENT_CERULEAN_GOT_BULBASAUR
	jr nz, .asm_1cfbf
	ld hl, CeruleanMelanieHouseMelanieIntroText
	call PrintText
	ld a, [wPikachuHappiness]
	cp 147
	jr c, .asm_1cfb3
	ld hl, CeruleanMelanieHouseMelanieDoYouWantItText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_1cfb6
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, BULBASAUR
	ld [wNamedObjectIndex], a
	ld [wCurPartySpecies], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	lb bc, BULBASAUR, 10
	call GivePokemon
	jr nc, .asm_1cfb3
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeruleanMelanieHouseMelanieTakeCareText
	call PrintText
	ld a, HS_CERULEAN_BULBASAUR
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_CERULEAN_GOT_BULBASAUR
.asm_1cfb3
	jp TextScriptEnd
.asm_1cfb6
	ld hl, CeruleanMelanieHouseMelanieIsItFineText
	call PrintText
	jp TextScriptEnd
.asm_1cfbf
	ld hl, CeruleanMelanieHouseMelanieIsItFineText
	call PrintText
	jp TextScriptEnd

CeruleanMelanieHouseMelanieIntroText:
	text_far _CeruleanMelanieHouseMelanieIntroText
	text_end

CeruleanMelanieHouseMelanieDoYouWantItText:
	text_far _CeruleanMelanieHouseMelanieDoYouWantItText
	text_end

CeruleanMelanieHouseMelanieTakeCareText:
	text_far _CeruleanMelanieHouseMelanieTakeCareText
	text_end

CeruleanMelanieHouseMelanieIsItFineText:
	text_far _CeruleanMelanieHouseMelanieIsItFineText
	text_end

CeruleanMelanieHouseMelanieThatsAShameText:
	text_far _CeruleanMelanieHouseMelanieThatsAShameText
	text_end

CeruleanMelanieHouseBulbasaurText:
	text_asm
	ld hl, CeruleanMelanieHousePrintBulbasaurText
	call PrintText
	ld a, BULBASAUR
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

CeruleanMelanieHousePrintBulbasaurText:
	text_far _CeruleanMelanieHouseBulbasaurText
	text_end

CeruleanMelanieHouseOddishText:
	text_asm
	ld hl, CeruleanMelanieHousePrintOddishText
	call PrintText
	ld a, ODDISH
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

CeruleanMelanieHousePrintOddishText:
	text_far _CeruleanMelanieHouseOddishText
	text_end

CeruleanMelanieHouseSandshrewText:
	text_asm
	ld hl, CeruleanMelanieHousePrintSandshrewText
	call PrintText
	ld a, SANDSHREW
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

CeruleanMelanieHousePrintSandshrewText:
	text_far _CeruleanMelanieHouseSandshrewText
	text_end