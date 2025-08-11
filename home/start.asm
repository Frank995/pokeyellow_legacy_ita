_Start::
	cp BOOTUP_A_GBC
	jr z, .gbc
	xor a
	jr .ok
.gbc
	ld a, TRUE
.ok
	ldh [hOnGBC], a
	jp Init
