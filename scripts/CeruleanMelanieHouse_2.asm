CeruleanMelanieHousePrintMelanieText:
	; Check if already got bulbasaur
	CheckEvent EVENT_CERULEAN_GOT_BULBASAUR
	jr nz, .got_bulbasaur

    ; Print greetings
	ld hl, CeruleanMelanieHouseMelanieIntroText
	call PrintText

    ; Check pikachu happiness
	ld a, [wPikachuHappiness]
	cp 147
	ret c

    ; If enough happy ask question
	ld hl, CeruleanMelanieHouseMelanieDoYouWantItText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .not_willing
    
    ; Willing to take it
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, BULBASAUR
	ld [wNamedObjectIndex], a
	ld [wCurPartySpecies], a
	call GetMonName
	lb bc, BULBASAUR, 10
	call GivePokemon
	ret nc ; full party

	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeruleanMelanieHouseMelanieTakeCareText
	call PrintText
	ld a, HS_MELANIES_HOUSE_BULBASAUR
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_CERULEAN_GOT_BULBASAUR
	ret
.not_willing
	ld hl, CeruleanMelanieHouseMelanieThatsAShameText
	call PrintText
	ret
.got_bulbasaur
	ld hl, CeruleanMelanieHouseMelanieIsItFineText
	call PrintText
	ret

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