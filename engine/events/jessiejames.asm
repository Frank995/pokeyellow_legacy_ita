PrintJJSpeechText::
    ld hl, JJSpeechText
    call PrintText
    ret

JJSpeechText:
	text_far _JJSpeechText
	text_end

PrintJJMeowthText::
    ld hl, JJMeowthText
    call PrintText
    ret

JJMeowthText:
	text_far _JJMeowthText
	text_end
