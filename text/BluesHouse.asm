_BluesHouseDaisyRivalAtLabText::
	text "Ciao <PLAYER>!"
	line "<RIVAL> è al"
	cont "laboratorio del"
	cont "nonno."
	para "Dovresti"
	line "sbrigarti!"
	done

_BluesHouseDaisyOfferMapText::
	text "Il nonno ti ha"
	line "chiesto di fare"
	cont "una commissione?"
	cont "Ecco, questo ti"
	cont "aiuterà!"
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
	line "grande!"
	cont "È molto utile!"
	done