PewterMart_Script:
	jp EnableAutoTextBoxDrawing

PewterMart_TextPointers:
	def_text_pointers
	dw_const PewterMartClerkText,     TEXT_PEWTERMART_CLERK
	dw_const PewterMartYoungsterText, TEXT_PEWTERMART_YOUNGSTER
	dw_const PewterMartSuperNerdText, TEXT_PEWTERMART_SUPER_NERD

PewterMartClerkText::
	script_mart POKE_BALL, POTION, ESCAPE_ROPE, REPEL, ANTIDOTE, PARLYZ_HEAL, AWAKENING

PewterMartYoungsterText:
	text_far _PewterMartYoungsterText
	text_end

PewterMartSuperNerdText:
	text_far _PewterMartSuperNerdText
	text_end
