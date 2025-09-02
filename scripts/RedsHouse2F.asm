RedsHouse2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2F_ScriptPointers
	ld a, [wRedsHouse2FCurScript]
	jp CallFunctionInTable

RedsHouse2F_ScriptPointers:
	def_script_pointers
	dw_const RedsHouse2FIntroCheckScript,     SCRIPT_REDSHOUSE2F_INTRO_CHECK
	dw_const RedsHouse2FIntroBubbleScript,    SCRIPT_REDSHOUSE2F_INTRO_BUBBLE
	dw_const RedsHouse2FIntroMoveRightScript, SCRIPT_REDSHOUSE2F_INTRO_MOVE_RIGHT
	dw_const RedsHouse2FIntroRemainderScript, SCRIPT_REDSHOUSE2F_INTRO_REMAINDER
	dw_const RedsHouse2FNoopScript,           SCRIPT_REDSHOUSE2F_NOOP

RedsHouse2FIntroCheckScript:
IF DEF(_DEBUG)
	jr .skip_intro
ENDC

	; Check if intro cutscene has already been shown
	CheckEvent EVENT_PALLET_PLAYER_WAKES_UP
	jr nz, .skip_intro
	
	; Disable player input
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Start the intro cutscene
	ld a, SCRIPT_REDSHOUSE2F_INTRO_BUBBLE
	ld [wRedsHouse2FCurScript], a
	ld [wCurMapScript], a
	ret

.skip_intro
	; Skip to noop script for normal gameplay
	ld a, SCRIPT_REDSHOUSE2F_NOOP
	ld [wRedsHouse2FCurScript], a
	ld [wCurMapScript], a
	ret

RedsHouse2FIntroBubbleScript:
	; Wait a little
	ld c, 70
	call DelayFrames
	
	; Show exclamation bubble on player
	ld a, 0  ; player's sprite index
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	
	; Wait for bubble animation
	ld c, 30
	call DelayFrames
	
	; Move to next script phase
	ld a, SCRIPT_REDSHOUSE2F_INTRO_MOVE_RIGHT
	ld [wRedsHouse2FCurScript], a
	ld [wCurMapScript], a
	ret

RedsHouse2FIntroMoveRightScript:
	; Define a 1-step movement to the right
	ld a, 1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_RIGHT
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates

	; Advance to next cutscene state
	ld a, SCRIPT_REDSHOUSE2F_INTRO_REMAINDER
	ld [wRedsHouse2FCurScript], a
	ld [wCurMapScript], a
	ret

RedsHouse2FIntroRemainderScript:
	; Display the cutscene text
	ld a, TEXT_REDSHOUSE2F_INTRO_REMAINDER
	ldh [hTextID], a
	call DisplayTextID

	; Re-enable player input
	xor a
	ld [wJoyIgnore], a
	
	; Mark cutscene as completed so it won't repeat
	SetEvent EVENT_PALLET_PLAYER_WAKES_UP
	
	; Switch to normal gameplay script
	ld a, SCRIPT_REDSHOUSE2F_NOOP
	ld [wRedsHouse2FCurScript], a
	ld [wCurMapScript], a
	ret

RedsHouse2FNoopScript:
	ret

RedsHouse2F_TextPointers:
	def_text_pointers
	dw_const RedsHouse2FSNESText,           TEXT_REDSHOUSE2F_SNES
	dw_const RedsHouse2FIntroRemainderText, TEXT_REDSHOUSE2F_INTRO_REMAINDER

RedsHouse2FSNESText:
	text_far _RedsHouse2FSNESText
	text_end

RedsHouse2FIntroRemainderText:
	text_far _RedsHouse2FIntroRemainderText
	text_end