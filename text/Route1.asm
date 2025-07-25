_Route1Youngster1MartSampleText::
	text "Ciao! Lavoro in un"
	line "#MON MARKET."

	para "È un negozio"
	line "comodo, quindi"
	cont "vieni a trovarci"
	cont "a SMERALDOPOLI."

	para "Lo so, ti darò"
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
	line "# BALL per"
	cont "catturare #MON!"
	done

_Route1Youngster1NoRoomText::
	text "Hai troppe cose"
	line "con te!"
	done

_Route1Youngster2Text::
	text "Conosci"
	line "l'esperienza"
	cont "STAT?"

	para "Quando un #MON"
	line "lotta, guadagna"
	cont "ESP."

	para "Questa ESP gli dà"
	line "statistiche"
	cont "migliori che"
	cont "gli allenatori"
	cont "nemici non hanno."

	para "Un #MON allenato"
	line "dal LIV 5 al"
	cont "LIV 50 potrebbe"
	cont "avere le"
	cont "statistiche di"
	cont "un avversario"
	cont "al LIV 60!"
	done

_Route1SignText::
	text "PERCORSO 1"
	line "BIANCAVILLA -"
	cont "SMERALDOPOLI"
	done
