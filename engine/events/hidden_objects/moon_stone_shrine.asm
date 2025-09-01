MtMoonShrinePrintText:
	call EnableAutoTextBoxDrawing
	tx_pre MtMoonShrineText
    ret

MtMoonShrineText::
	text_far _MtMoonShrineText
	text_end
