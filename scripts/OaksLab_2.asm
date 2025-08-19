OaksLabPrintOakText::
	ld hl, OaksLabOakAroundTheWorldText
	call PrintText
	ret

OaksLabOakAroundTheWorldText:
	text_far _OaksLabOakAroundTheWorldText
	text_end
