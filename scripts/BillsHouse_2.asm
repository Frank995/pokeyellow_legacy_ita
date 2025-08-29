BillsHousePrintBillPokemonText::
	ld hl, BillsHouseBillImNotAPokemonText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .answered_no
.use_machine
	ld hl, BillsHouseBillUseSeparationSystemText
	call PrintText
	ld a, SCRIPT_BILLSHOUSE_SCRIPT2
	ld [wBillsHouseCurScript], a
	ret
.answered_no
	ld hl, BillsHouseBillNoYouGottaHelpText
	call PrintText
	jr .use_machine

BillsHouseBillImNotAPokemonText:
	text_far _BillsHouseBillImNotAPokemonText
	text_end

BillsHouseBillUseSeparationSystemText:
	text_far _BillsHouseBillUseSeparationSystemText
	text_end

BillsHouseBillNoYouGottaHelpText:
	text_far _BillsHouseBillNoYouGottaHelpText
	text_end

BillsHousePrintBillSSTicketText::
	CheckEvent EVENT_BILLS_HOUSE_GOT_SS_TICKET
	jr nz, .got_ss_ticket
	ld hl, BillsHouseBillThankYouText
	call PrintText
	lb bc, S_S_TICKET, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, _BillsHouseBillSSTicketReceivedText
	call PrintText
	SetEvent EVENT_BILLS_HOUSE_GOT_SS_TICKET
.got_ss_ticket
	ld hl, BillsHouseBillWhyDontYouGoInsteadOfMeText
	call PrintText
	ret
.bag_full
	ld hl, BillsHouseBillSSTicketNoRoomText
	call PrintText
	ret

BillsHouseBillThankYouText:
	text_far _BillsHouseBillThankYouText
	text_end

BillsHouseBillSSTicketReceivedText:
	text_far _BillsHouseBillSSTicketReceivedText
	sound_get_key_item
	text_promptbutton
	text_end

BillsHouseBillSSTicketNoRoomText:
	text_far _BillsHouseBillSSTicketNoRoomText
	text_end

BillsHouseBillWhyDontYouGoInsteadOfMeText:
	text_far _BillsHouseBillWhyDontYouGoInsteadOfMeText
	text_end

Func_f24ae::
	ld a, [wCurMap]
	cp BILLS_HOUSE
	jr nz, .asm_f24d2
	call CheckPikachuFollowingPlayer
	jr z, .asm_f24d2
	ld a, [wBillsHouseCurScript]
	cp SCRIPT_BILLSHOUSE_SCRIPT5
	ldpikaemotion e, PikachuEmotion27
	ret z
	cp SCRIPT_BILLSHOUSE_SCRIPT0
	ldpikaemotion e, PikachuEmotion23
	ret z
	CheckEventHL EVENT_BILLS_HOUSE_MET_BILL_2
	ldpikaemotion e, PikachuEmotion32
	ret z
	ldpikaemotion e, PikachuEmotion31
	ret

.asm_f24d2
	ld e, $ff
	ret

Func_f24d5::
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	xor a
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	call UpdateSprites
	ld hl, Data_f2505
	call ApplyPikachuMovementData
	ld a, $f ; pikachu
	ld [wEmotionBubbleSpriteIndex], a
	ld a, QUESTION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	call DisablePikachuFollowingPlayer
	callfar InitializePikachuTextID
	ret

Data_f2505:
	db $00
	db $20
	db $20
	db $20
	db $1e
	db $3f

Func_f250b::
	ld hl, Data_f251c
	ld b, SPRITE_FACING_UP
	call TryApplyPikachuMovementData
	ld hl, Data_f2521
	ld b, SPRITE_FACING_RIGHT
	call TryApplyPikachuMovementData
	ret

Data_f251c:
	db $00
	db $1f
	db $1d
	db $38
	db $3f

Data_f2521:
	db $00
	db $1e
	db $1f
	db $1f
	db $1d
	db $38
	db $3f
