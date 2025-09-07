BluesHouse_Script:
	jp EnableAutoTextBoxDrawing

BluesHouse_TextPointers:
	def_text_pointers
	dw_const BluesHouseDaisyText,   TEXT_BLUESHOUSE_DAISY
	dw_const BluesHouseTownMapText, TEXT_BLUESHOUSE_TOWN_MAP

BluesHouseDaisyText:
	text_asm
	callfar BluesHousePrintDaisyText
	jp TextScriptEnd

BluesHouseTownMapText:
	text_far _BluesHouseTownMapText
	text_end
