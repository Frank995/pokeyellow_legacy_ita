PalletTown_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PalletTown_ScriptPointers
	ld a, [wPalletTownCurScript]
	jp CallFunctionInTable

PalletTown_ScriptPointers:
	def_script_pointers
	dw_const PalletTownIntroCheckScript,   SCRIPT_PALLETTOWN_INTRO_CHECK
	dw_const PalletTownIntroBubbleScript,  SCRIPT_PALLETTOWN_INTRO_BUBBLE
	dw_const PalletTownIntroHeyWaitScript, SCRIPT_PALLETTOWN_INTRO_HEY_WAIT
	dw_const PalletTownNoopScript,         SCRIPT_PALLETTOWN_NOOP

PalletTownIntroCheckScript:
	; Check if the player has already played the intro at Oak's
	CheckEvent EVENT_STARTER_BATTLED_RIVAL
	jr nz, .skip_check

	; Check position
	ld a, [wYCoord]
	cp 0 ; is player at north exit?
	ret nz
	
	; Stop player movement if player is going out
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	
	ld a, SCRIPT_PALLETTOWN_INTRO_BUBBLE
	ld [wPalletTownCurScript], a
	ld [wCurMapScript], a
	ret
.skip_check
	; Skip to noop script for normal gameplay
	ld a, SCRIPT_PALLETTOWN_NOOP
	ld [wPalletTownCurScript], a
	ld [wCurMapScript], a
	ret

PalletTownIntroBubbleScript:
	; Wait a little
	ld c, 20
	call DelayFrames

	; Show question bubble on player
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld a, QUESTION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	
	; Wait for bubble animation
	ld c, 30
	call DelayFrames

	ld a, SCRIPT_PALLETTOWN_INTRO_HEY_WAIT
	ld [wPalletTownCurScript], a
	ld [wCurMapScript], a
	ret

PalletTownIntroHeyWaitScript:
	; Display the text immediately
	ld a, TEXT_PALLETTOWN_INTRO_HEY_WAIT
	ldh [hTextID], a
	call DisplayTextID

	; Move player down 2 tiles immediately after text starts
	ld a, 2  
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a     
	ld [wSimulatedJoypadStatesEnd+1], a   
	call StartSimulatingJoypadStates

	; Reenable input
	xor a
	ld [wJoyIgnore], a

	; Reset to default script immediately
	ld a, SCRIPT_PALLETTOWN_INTRO_CHECK
	ld [wPalletTownCurScript], a
	ld [wCurMapScript], a
	ret

PalletTownNoopScript:
	ret

PalletTown_TextPointers:
	def_text_pointers
	dw_const PalletTownGirlText,             TEXT_PALLETTOWN_GIRL
	dw_const PalletTownFisherText,           TEXT_PALLETTOWN_FISHER
	dw_const PalletTownOaksLabSignText,      TEXT_PALLETTOWN_OAKSLAB_SIGN
	dw_const PalletTownSignText,             TEXT_PALLETTOWN_SIGN
	dw_const PalletTownPlayersHouseSignText, TEXT_PALLETTOWN_PLAYERSHOUSE_SIGN
	dw_const PalletTownRivalsHouseSignText,  TEXT_PALLETTOWN_RIVALSHOUSE_SIGN
	dw_const PalletTownIntroHeyWaitText,     TEXT_PALLETTOWN_INTRO_HEY_WAIT

PalletTownGirlText:
	text_far _PalletTownGirlText
	text_end

PalletTownFisherText:
	text_far _PalletTownFisherText
	text_end

PalletTownOaksLabSignText:
	text_far _PalletTownOaksLabSignText
	text_end

PalletTownSignText:
	text_far _PalletTownSignText
	text_end

PalletTownPlayersHouseSignText:
	text_far _PalletTownPlayersHouseSignText
	text_end

PalletTownRivalsHouseSignText:
	text_far _PalletTownRivalsHouseSignText
	text_end

PalletTownIntroHeyWaitText:
	text_far _PalletTownHeyWaitText
	text_end
