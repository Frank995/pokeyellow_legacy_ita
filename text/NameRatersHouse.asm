_NameRatersHouseNameRaterWantMeToRateText::
	text "Ciao, ciao!"
	line "Io sono il"
	cont "GIUDICE"
	cont "ONOMASTICO!"

	para "Vuoi che valuti"
	line "i soprannomi dei"
	cont "tuoi #MON?"
	done

_NameRatersHouseNameRaterWhichPokemonText::
	text "Quale #MON"
	line "dovrei guardare?"
	prompt

_NameRatersHouseNameRaterGiveItANiceNameText::
	text_ram wNameBuffer
	text ", vero?"
	line "È un soprannome"
	cont "decente!"

	para "Ma, vorresti che"
	line "gli dessi un nome"
	cont "più carino?"

	para "Che ne dici?"
	done

_NameRatersHouseNameRaterWhatShouldWeNameItText::
	text "Bene! Come"
	line "dovremmo"
	cont "chiamarlo?"
	prompt

_NameRatersHouseNameRaterPokemonHasBeenRenamedText::
	text "OK! Questo #MON"
	line "è stato rinomi-"
	cont "nato @"
	text_ram wBuffer
	text "!"

	para "È un nome migliore"
	line "di prima!"
	done

_NameRatersHouseNameRaterComeAnyTimeYouLikeText::
	text "Bene! Torna quando"
	line "vuoi!"
	done

_NameRatersHouseNameRaterATrulyImpeccableNameText::
	text_ram wNameBuffer
	text ", vero?"
	line "È davvero un nome"
	cont "impeccabile!"

	para "Prenditi cura di"
	line "@"
	text_ram wNameBuffer
	text "!"
	done