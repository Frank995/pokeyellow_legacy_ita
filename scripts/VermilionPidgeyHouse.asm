VermilionPidgeyHouse_Script:
	jp EnableAutoTextBoxDrawing

VermilionPidgeyHouse_TextPointers:
	def_text_pointers
	dw_const VermilionPidgeyHouseYoungsterText, TEXT_VERMILIONPIDGEYHOUSE_YOUNGSTER
	dw_const VermilionPidgeyHousePidgeyText,    TEXT_VERMILIONPIDGEYHOUSE_PIDGEY
	dw_const VermilionPidgeyHouseLetterText,    TEXT_VERMILIONPIDGEYHOUSE_LETTER

VermilionPidgeyHouseYoungsterText:
	text_far _VermilionPidgeyHouseYoungsterText
	text_end

VermilionPidgeyHousePidgeyText:
	text_asm
	ld hl, VermilionPidgeyHousePrintPidgeyText
	call PrintText
	ld a, PIDGEY
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

VermilionPidgeyHousePrintPidgeyText:
	text_far _VermilionPidgeyHousePidgeyText
	text_end

VermilionPidgeyHouseLetterText:
	text_far _VermilionPidgeyHouseLetterText
	text_end
