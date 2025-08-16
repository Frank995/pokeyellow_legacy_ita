_Route1Youngster1MartSampleText::
	text "Ciao! Lavoro in un"
	line "#MON MARKET."

	para "È un negozio"
	line "comodo, quindi"
	cont "vieni a trovarci"
	cont "a SMERALDOPOLI."

	para "Capito, ti darò"
	line "un campione!"
	cont "Ecco a te!"
	prompt

_Route1Youngster1GotPotionText::
	text "<PLAYER> ha"
	line "ottenuto @"
	text_ram wStringBuffer
	text "!@"
	text_end

_Route1Youngster1AlsoGotPokeballsText::
	text "Vendiamo anche"
	line "# BALL per ca-"
	cont "tturare #MON!"
	done

_Route1Youngster1NoRoomText::
	text "Hai troppe cose"
	line "con te!"
	done

_Route1Youngster2Text::
	text "Vedi quei terraz-"
	line "zamenti lungo la"
	cont "strada?"

	para "Fa un po' paura,"
	line "ma puoi saltarci"
	cont "da sopra."

	para "Puoi tornare a"
	line "BIANCAVILLA più"
	cont "velocemente"
	cont "così."
	done

_Route1SignText::
	text "PERCORSO 1"
	line "BIANCAVILLA -"
	cont "SMERALDOPOLI"
	done