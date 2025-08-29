Route22PrintRival1Text::
	CheckEvent EVENT_ROUTE_22_BEAT_RIVAL1
	jr z, .before_battle
	ld hl, Route22RivalAfterBattleText1
	call PrintText
	jr .text_script_end
.before_battle
	ld hl, Route22RivalBeforeBattleText1
	call PrintText
.text_script_end
	ret

Route22RivalBeforeBattleText1:
	text_far _Route22Rival1BeforeBattleText
	text_end

Route22RivalAfterBattleText1:
	text_far _Route22Rival1AfterBattleText
	text_end

Route22PrintRival2Text::
	CheckEvent EVENT_ROUTE_22_BEAT_RIVAL2
	jr z, .before_battle
	ld hl, Route22RivalAfterBattleText2
	call PrintText
	jr .text_script_end
.before_battle
	ld hl, Route22RivalBeforeBattleText2
	call PrintText
.text_script_end
	ret

Route22RivalBeforeBattleText2:
	text_far _Route22Rival2BeforeBattleText
	text_end

Route22RivalAfterBattleText2:
	text_far _Route22Rival2AfterBattleText
	text_end
