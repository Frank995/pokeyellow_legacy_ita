_MoveDeleterGreetingText::
	text "Vuoi che faccia"
	line "dimenticare una"
	cont "mossa a un"
	cont "#MON?"
	done

_MoveDeleterSaidYesText::
	text "A quale #MON"
	line "devo far"
	cont "dimenticare una"
	cont "mossa?"
	prompt

_MoveDeleterWhichMoveText::
	text "Quale mossa deve"
	line "dimenticare?"
	done

_MoveDeleterConfirmText::
	text "Far dimenticare"
	line "@"
	text_ram wStringBuffer
	text "?"
	prompt

_MoveDeleterForgotText::
	text "@"
	text_ram wStringBuffer
	text " è stata"
	line "dimenticata!"
	prompt

_MoveDeleterByeText::
	text "Torna a trovarmi"
	line "ancora!"
	done

_MoveDeleterOneMoveText::
	text "Quel #MON ha"
	line "una sola mossa."
	cont "Ne scegli un"
	cont "altro?"
	done