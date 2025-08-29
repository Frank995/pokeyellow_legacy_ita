CeruleanTrashedHouse_Script:
	jp EnableAutoTextBoxDrawing

CeruleanTrashedHouse_TextPointers:
	def_text_pointers
	dw_const CeruleanTrashedHouseFishingGuruText, TEXT_CERULEANTRASHEDHOUSE_FISHING_GURU
	dw_const CeruleanTrashedHouseGirlText,        TEXT_CERULEANTRASHEDHOUSE_GIRL
	dw_const CeruleanTrashedHouseWallHoleText,    TEXT_CERULEANTRASHEDHOUSE_WALL_HOLE

CeruleanTrashedHouseFishingGuruText:
	text_asm
	ld b, TM_DIG
	predef GetQuantityOfItemInBag
	and b
	jr z, .no_dig_tm
	ld hl, CeruleanTrashedHouseFishingGuruWhatsLostIsLostText
	call PrintText
	jr .done
.no_dig_tm
	ld hl, CeruleanTrashedHouseFishingGuruTheyStoleATMText
	call PrintText
.done
	jp TextScriptEnd

CeruleanTrashedHouseFishingGuruTheyStoleATMText:
	text_far _CeruleanTrashedHouseFishingGuruTheyStoleATMText
	text_end

CeruleanTrashedHouseFishingGuruWhatsLostIsLostText:
	text_far _CeruleanTrashedHouseFishingGuruWhatsLostIsLostText
	text_end

CeruleanTrashedHouseGirlText:
	text_far _CeruleanTrashedHouseGirlText
	text_end

CeruleanTrashedHouseWallHoleText:
	text_far _CeruleanTrashedHouseWallHoleText
	text_end
