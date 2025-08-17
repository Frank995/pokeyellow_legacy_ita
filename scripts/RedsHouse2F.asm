RedsHouse2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2F_ScriptPointers
	ld a, [wRedsHouse2FCurScript]
	jp CallFunctionInTable

RedsHouse2F_ScriptPointers:
	def_script_pointers
	dw_const RedsHouse2FCheckIntroScript,    SCRIPT_REDSHOUSE2F_CHECK_INTRO
	dw_const RedsHouse2FIntroMoveRightScript, SCRIPT_REDSHOUSE2F_INTRO_MOVE_RIGHT
	dw_const RedsHouse2FIntroBubbleScript,   SCRIPT_REDSHOUSE2F_INTRO_BUBBLE
	dw_const RedsHouse2FIntroShowTextScript, SCRIPT_REDSHOUSE2F_INTRO_SHOW_TEXT
	dw_const RedsHouse2FDefaultScript,       SCRIPT_REDSHOUSE2F_DEFAULT

RedsHouse2FCheckIntroScript:
	; Check if intro cutscene has already been shown
	CheckEvent EVENT_RED_WAKE_UP
	jr nz, .skip_intro
	
	; Disable player input during cutscene
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	; Start the intro cutscene
	ld a, SCRIPT_REDSHOUSE2F_INTRO_MOVE_RIGHT
	ld [wRedsHouse2FCurScript], a
	ret
	
.skip_intro
	; Skip to default script for normal gameplay
	ld a, SCRIPT_REDSHOUSE2F_DEFAULT
	ld [wRedsHouse2FCurScript], a
	ret

RedsHouse2FIntroMoveRightScript:
	; Define a 1-step movement to the right
	ld a, 1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_RIGHT
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates

	; Advance to next cutscene state
	ld a, SCRIPT_REDSHOUSE2F_INTRO_BUBBLE
	ld [wRedsHouse2FCurScript], a
	ret

RedsHouse2FIntroBubbleScript:
	; Wait for moving animation
	ld c, 20
	call DelayFrames
	
	; Show exclamation bubble on player
	ld a, 0  ; player's sprite index
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	
	; Wait for bubble animation + pause
	ld c, 60  ; ~1 second pause
	call DelayFrames
	
	; Move to next script phase
	ld a, SCRIPT_REDSHOUSE2F_INTRO_SHOW_TEXT
	ld [wRedsHouse2FCurScript], a
	ret

RedsHouse2FIntroShowTextScript:
	; Display the cutscene message
	ld a, TEXT_REDSHOUSE2F_INTRO_MESSAGE
	ldh [hTextID], a
	call DisplayTextID
	
	; Re-enable player input
	xor a
	ld [wJoyIgnore], a
	
	; Mark cutscene as completed so it won't repeat
	SetEvent EVENT_RED_WAKE_UP
	
	; Switch to normal gameplay script
	ld a, SCRIPT_REDSHOUSE2F_DEFAULT
	ld [wRedsHouse2FCurScript], a
	ret

RedsHouse2FDefaultScript:
	; Normal gameplay - no special scripting needed
	ret

RedsHouse2F_TextPointers:
	def_text_pointers
	dw_const RedsHouse2FIntroMessageText, TEXT_REDSHOUSE2F_INTRO_MESSAGE
	dw_const RedsHouse2FSNESText,  TEXT_REDSHOUSE2F_SNES

RedsHouse2FIntroMessageText:
	text_far _RedsHouse2FIntroMessageText
	text_end

RedsHouse2FSNESText:
	text_far _RedsHouse2FSNESText
	text_end
