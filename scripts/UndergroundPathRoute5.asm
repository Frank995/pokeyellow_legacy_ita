UndergroundPathRoute5_Script:
	ld a, ROUTE_5
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathRoute5_TextPointers:
	def_text_pointers
	dw_const UndergroundPathRoute5LittleGirlText, TEXT_UNDERGROUNDPATHROUTE5_LITTLE_GIRL

UndergroundPathRoute5LittleGirlText:
	text_asm
	ld a, TRADE_FOR_RICKY
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	ld hl, UndergroundPathRoute5LittleGirlEndText
	ret

UndergroundPathRoute5LittleGirlEndText:
	text_end
