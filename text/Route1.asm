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

_Route1OakBeforeBattleText::
	text "OAK: Oh,"
	line "mamma mia!"
	
	para "Sembra che tu mi"
	line "abbia beccato"
	cont "durante la pausa"
	cont "pranzo!"

	para "<PLAYER>, sei"
	line "davvero diventato"
	cont "indipendente!"

	para "La tua sfida alla"
	line "LEGA #MON ha"
	cont "riacceso uno"
	cont "spirito che mi"
	cont "aveva lasciato"
	cont "molto tempo fa..."

	para "Che ne dici se"
	line "facciamo un pò"
	cont "di allenamento?"
	cont "Che ne pensi?"
	done

_Route1OakRealChallengeBattleText::
	text "Eccellente!"

	para "Preparati per"
	line "una vera sfida!"
	done

_Route1OakRefusedBattleText::
	text "Magari un'altra"
	line "volta!"
	done

_Route1OakBattleLostText::
	text "Hmm..."

	para "Ho ancora molto"
	line "da imparare!"
	prompt

_Route1OakBattleWonText::
	text "Ai miei tempi,"
	line "ero un ALLENATORE"
	cont "serio!"
	prompt

_Route1PostOakBattleText::
	text "Ben fatto,"
	line "<PLAYER>!"

	para "Hai certamente"
	line "dimostrato il"
	cont "tuo valore."

	para "Sembra che io"
	line "stia invecchiando"
	cont "un pò con"
	cont "l'età."

	para "Un buon allenatore"
	line "cerca sempre di"
	cont "migliorarsi, e"
	cont "così farò anch'io."

	para "Possa il tuo"
	line "viaggio continuare"
	cont "ad essere uno di"
	cont "crescita e"
	cont "scoperta."
	done