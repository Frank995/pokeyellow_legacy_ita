PewterCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PewterCity_ScriptPointers
	ld a, [wPewterCityCurScript]
	jp CallFunctionInTable

PewterCity_ScriptPointers:
	def_script_pointers
	dw_const PewterCityDefaultScript,      SCRIPT_PEWTERCITY_DEFAULT
	dw_const PewterCityLeaveBubbleScript,  SCRIPT_PEWTERCITY_LEAVE_BUBBLE
	dw_const PewterCityLeaveMessageScript, SCRIPT_PEWTERCITY_LEAVE_MESSAGE
	

PewterCityDefaultScript:
	xor a
	ld [wMuseum1FCurScript], a
	ResetEvent EVENT_PEWTER_BOUGHT_MUSEUM_TICKET
	call PewterCityLeaveCheckPlayerScript
	ret

PewterCityLeaveCheckPlayerScript:
	CheckEvent EVENT_PEWTER_GYM_BEAT_BROCK
	ret nz
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	ld hl, PewterCityLeaveCheckPlayerCoordinates
	call ArePlayerCoordsInArray
	ret nc

	; Block player
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	ld a, SCRIPT_PEWTERCITY_LEAVE_BUBBLE
	ld [wPewterCityCurScript], a
	ld [wCurMapScript], a
	ret

PewterCityLeaveCheckPlayerCoordinates:
	dbmapcoord 35, 17
	dbmapcoord 35, 18
	dbmapcoord 35, 19
	db -1 ; end

PewterCityLeaveBubbleScript:
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

	ld a, SCRIPT_PEWTERCITY_LEAVE_MESSAGE
	ld [wPewterCityCurScript], a
	ld [wCurMapScript], a
	ret

PewterCityLeaveMessageScript:
	; Display the text
	ld a, TEXT_PEWTERCITY_YOUNGSTER
	ldh [hTextID], a
	call DisplayTextID

	; Move player down 2 tiles immediately after text starts
	ld a, 2  
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_LEFT
	ld [wSimulatedJoypadStatesEnd], a     
	ld [wSimulatedJoypadStatesEnd+1], a   
	call StartSimulatingJoypadStates

	; Reenable input
	xor a
	ld [wJoyIgnore], a

	; Reset to default script immediately
	ld a, SCRIPT_PEWTERCITY_DEFAULT
	ld [wPewterCityCurScript], a
	ld [wCurMapScript], a
	ret

PewterCity_TextPointers:
	def_text_pointers
	dw_const PewterCityCooltrainerFText,           TEXT_PEWTERCITY_COOLTRAINER_F
	dw_const PewterCityCooltrainerMText,           TEXT_PEWTERCITY_COOLTRAINER_M
	dw_const PewterCitySuperNerd1Text,             TEXT_PEWTERCITY_SUPER_NERD1
	dw_const PewterCitySuperNerd2Text,             TEXT_PEWTERCITY_SUPER_NERD2
	dw_const PewterCityYoungsterText,              TEXT_PEWTERCITY_YOUNGSTER
	dw_const PewterCityTrainerTipsText,            TEXT_PEWTERCITY_TRAINER_TIPS
	dw_const PewterCityPoliceNoticeSignText,       TEXT_PEWTERCITY_POLICE_NOTICE_SIGN
	dw_const MartSignText,                         TEXT_PEWTERCITY_MART_SIGN
	dw_const PokeCenterSignText,                   TEXT_PEWTERCITY_POKECENTER_SIGN
	dw_const PewterCityMuseumSignText,             TEXT_PEWTERCITY_MUSEUM_SIGN
	dw_const PewterCityGymSignText,                TEXT_PEWTERCITY_GYM_SIGN
	dw_const PewterCitySignText,                   TEXT_PEWTERCITY_SIGN

PewterCityCooltrainerFText:
	text_far _PewterCityCooltrainerFText
	text_end

PewterCityCooltrainerMText:
	text_far _PewterCityCooltrainerMText
	text_end

PewterCitySuperNerd1Text:
	text_asm
	farcall PewterCityPrintSuperNerd1Text
	jp TextScriptEnd

PewterCitySuperNerd2Text:
	text_far _PewterCitySuperNerd2Text
	text_end

PewterCityYoungsterText:
	text_far _PewterCityYoungsterText
	text_end

PewterCityTrainerTipsText:
	text_far _PewterCityTrainerTipsText
	text_end

PewterCityPoliceNoticeSignText:
	text_far _PewterCityPoliceNoticeSignText
	text_end

PewterCityMuseumSignText:
	text_far _PewterCityMuseumSignText
	text_end

PewterCityGymSignText:
	text_far _PewterCityGymSignText
	text_end

PewterCitySignText:
	text_far _PewterCitySignText
	text_end
