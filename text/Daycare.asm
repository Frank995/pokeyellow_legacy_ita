_DaycareGentlemanIntroText::
	text "Gestisco una"
	line "PENSIONE #MON."
	cont "Vorresti che io"
	cont "allevessi uno dei"
	cont "tuoi #MON?"
	done

_DaycareGentlemanWhichMonText::
	text "Quale #MON"
	line "dovrei allevare?"
	prompt

_DaycareGentlemanWillLookAfterMonText::
	text "Bene, mi prenderò"
	line "cura di @"
	text_ram wNameBuffer
	text_start
	cont "per un pò."
	prompt

_DaycareGentlemanComeSeeMeInAWhileText::
	text "Vieni a trovarmi"
	line "fra un pò."
	done

_DaycareGentlemanMonHasGrownText::
	text "Il tuo @"
	text_ram wNameBuffer
	text_start
	line "è cresciuto"
	cont "molto!"

	para "Di livello, è"
	line "cresciuto di @"
	text_decimal wDayCareNumLevelsGrown, 1, 3
	text "!"

	para "Non sono bravo?"
	prompt

_DaycareGentlemanOweMoneyText::
	text "Mi devi ¥@"
	text_bcd wDayCareTotalCost, 2 | LEADING_ZEROES | LEFT_ALIGN
	text_start
	line "per la"
	cont "restituzione di"
	cont "questo #MON."
	done

_DaycareGentlemanGotMonBackText::
	text "<PLAYER> ha"
	line "riavuto @"
	text_ram wDayCareMonName
	text "!"
	done

_DaycareGentlemanMonNeedsMoreTimeText::
	text "Già di ritorno?"
	line "Il tuo @"
	text_ram wNameBuffer
	text_start
	cont "ha bisogno di"
	cont "restare ancora"
	cont "un pò."
	prompt

_DaycareGentlemanAllRightThenText::
	text "Va bene allora,"
	line "@"
	text_end

_DaycareGentlemanComeAgainText::
	text "Torna quando vuoi."
	done

_DaycareGentlemanNoRoomForMonText::
	text "Non hai spazio per"
	line "questo #MON!"
	done

_DaycareGentlemanOnlyHaveOneMonText::
	text "Hai solo un"
	line "#MON con te."
	done

_DaycareGentlemanCantAcceptStarterPikachuText::
	text "Sembra che questo"
	line "PIKACHU non"
	cont "voglia venire."
	done

_DaycareGentlemanHeresYourMonText::
	text "Grazie! Ecco il"
	line "tuo #MON!"
	prompt

_DaycareGentlemanNotEnoughMoneyText::
	text "Ehi, non hai"
	line "abbastanza ¥!"
	done