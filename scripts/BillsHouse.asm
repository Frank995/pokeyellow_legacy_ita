BillsHouse_Script:
	call EnableAutoTextBoxDrawing
	ld hl, BillsHouse_ScriptPointers
	ld a, [wBillsHouseCurScript]
	jp CallFunctionInTable

BillsHouse_ScriptPointers:
	def_script_pointers
	dw_const BillsHouseCostumeCheckScript, SCRIPT_BILLSHOUSE_COSTUME_CHECK
	dw_const BillsHouseNoopScript,         SCRIPT_BILLSHOUSE_NOOP

BillsHouseCostumeCheckScript:
	; Skip if already helped bill or haven't talked to him yet
	CheckEvent EVENT_BILLS_HOUSE_ASKED_FOR_HELP
	ret z
	CheckEvent EVENT_BILLS_HOUSE_HELPED_BILL
	jr nz, .noop

	; Skip if not behind bill
	ld hl, BillsHouseBillCoordsArray
	call ArePlayerCoordsInArray
	ret nc

	; Check if clicked A while facing costume
	ldh a, [hJoyPressed]
	bit B_PAD_A, a
	ret z
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_DOWN
	ret nz

	; Wait a little
	ld c, 30
	call DelayFrames
	ld a, HS_BILLS_HOUSE_KABUTO
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BILLS_HOUSE_BILL
	ld [wMissableObjectIndex], a
	predef ShowObject

	; Turn bill and play dialogue
	ld a, BILLSHOUSE_BILL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_BILLSHOUSE_BILL
	ldh [hTextID], a
	call DisplayTextID
	; fallthrough
.noop
	ld a, SCRIPT_BILLSHOUSE_NOOP
	ld [wBillsHouseCurScript], a
	ld [wCurMapScript], a
	ret

BillsHouseBillCoordsArray:
	dbmapcoord 4, 2
	db -1 ; end

BillsHouseNoopScript:
	ret

BillsHouse_TextPointers:
	def_text_pointers
	dw_const BillsHouseKabutoText, TEXT_BILLSHOUSE_KABUTO
	dw_const BillsHouseBillText,   TEXT_BILLSHOUSE_BILL

BillsHouseKabutoText:
	text_asm
	callfar BillsHousePrintKabutoText
	jp TextScriptEnd

BillsHouseBillText:
	text_asm
	callfar BillsHousePrintBillText
	jp TextScriptEnd