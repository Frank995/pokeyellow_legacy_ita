PalletTown_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PalletTown_ScriptPointers
	ld a, [wPalletTownCurScript]
	jp CallFunctionInTable

PalletTown_ScriptPointers:
	def_script_pointers
	dw_const PalletTownDefaultScript, SCRIPT_PALLETTOWN_DEFAULT
	dw_const PalletTownHeyWaitScript, SCRIPT_PALLETTOWN_HEY_WAIT

PalletTownDefaultScript:
	; Check if the player has already played the intro at Oak's
	CheckEvent EVENT_STARTER_BATTLED_RIVAL
	ret nz  ; return if player has already the starter

	; Check position
	ld a, [wYCoord]
	cp 0 ; is player at north exit?
	ret nz
	
	; Stop player movement if player is going out
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	
	; Show question bubble on player
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld a, QUESTION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	
	; Wait for bubble animation
	ld c, 30
	call DelayFrames
	
	; Trigger the next script
	ld a, SCRIPT_PALLETTOWN_HEY_WAIT
	ld [wPalletTownCurScript], a
	ret

PalletTownHeyWaitScript:
	; Re-enable player input immediately
	xor a
	ld [wJoyIgnore], a

	; Display the text immediately
	ld a, TEXT_PALLETTOWN_HEY_WAIT
	ldh [hTextID], a
	call DisplayTextID

	; Move player down 2 tiles immediately after text starts
	ld a, 2  
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a     
	ld [wSimulatedJoypadStatesEnd+1], a   
	call StartSimulatingJoypadStates

	; Reset to default script immediately
	ld a, SCRIPT_PALLETTOWN_DEFAULT
	ld [wPalletTownCurScript], a
	ret

PalletTown_TextPointers:
	def_text_pointers
	dw_const PalletTownGirlText,             TEXT_PALLETTOWN_GIRL
	dw_const PalletTownFisherText,           TEXT_PALLETTOWN_FISHER
	dw_const PalletTownOaksLabSignText,      TEXT_PALLETTOWN_OAKSLAB_SIGN
	dw_const PalletTownSignText,             TEXT_PALLETTOWN_SIGN
	dw_const PalletTownPlayersHouseSignText, TEXT_PALLETTOWN_PLAYERSHOUSE_SIGN
	dw_const PalletTownRivalsHouseSignText,  TEXT_PALLETTOWN_RIVALSHOUSE_SIGN
	dw_const PalletTownHeyWaitText,          TEXT_PALLETTOWN_HEY_WAIT

PalletTownGirlText:
	text_far _PalletTownGirlText
	text_end

PalletTownFisherText:
	text_far _PalletTownFisherText
	text_end

PalletTownHeyWaitText:
	text_far _PalletTownHeyWaitText
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