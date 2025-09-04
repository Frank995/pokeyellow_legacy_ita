CeruleanMelaniesHouse_Script:
	jp EnableAutoTextBoxDrawing

CeruleanMelaniesHouse_TextPointers:
	def_text_pointers
	dw_const CeruleanMelanieHouseMelanieText, TEXT_CERULEANMELANIESHOUSE_MELANIE
	dw_const CeruleanMelanieHouseBulbasaurText, TEXT_CERULEANMELANIESHOUSE_BULBASAUR
	dw_const CeruleanMelanieHouseOddishText, TEXT_CERULEANMELANIESHOUSE_ODDISH
	dw_const CeruleanMelanieHouseSandshrewText, TEXT_CERULEANMELANIESHOUSE_SANDSHREW

CeruleanMelanieHouseMelanieText:
	text_asm
	callfar CeruleanMelanieHousePrintMelanieText
	jp TextScriptEnd

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