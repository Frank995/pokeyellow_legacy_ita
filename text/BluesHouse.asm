_BluesHouseDaisyRivalAtLabText::
	text "Ciao <PLAYER>!"
	line "<RIVAL> è al"
	cont "laboratorio del"
	cont "nonno."

	para "Non dovevi andare"
	line "anche te?"
	done

_BluesHouseDaisyOfferMapText::
	text "Quindi il nonno ti"
	line "ha affidato un"
	cont "#MON?"

	para "Ecco, questo ti"
	line "aiuterà nei tuoi"
	cont "viaggi!"
	prompt

_BluesHouseDaisyGotMapText::
	text "<PLAYER> ha"
	line "ottenuto una"
	cont "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_BluesHouseDaisyUseMapText::
	text "Usa la MAPPA CIT-"
	line "TÀ per scoprire"
	cont "dove ti trovi."
	done

_BluesHouseDaisyBagFullText::
	text "Hai troppe cose"
	line "con te."
	done

_BluesHouseDaisyWalkingText::
	text "Passare del tempo"
	line "con i tuoi"
	cont "#MON li rende"
	cont "più amichevoli."
	done

_BluesHouseTownMapText::
	text "È una mappa"
	line "di KANTO!"
	cont "È molto utile!"
	done