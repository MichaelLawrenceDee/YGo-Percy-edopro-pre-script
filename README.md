Functions:

Duel.RockPaperScissors([repeat = true]) - returns int (winner or PLAYER_NONE)

Duel.GetRandomNumber([int min,]int max)

Card.GetCardEffect(card, int code) returns all the effect with that code applied on a card

Duel.GetPlayerEffect(int tp, int code) returns all the effect with that code applied on the player

Effects:

EFFECT_CANNOT_SPECIAL_SUMMON now can accept the position as filter by putting it as the value, the inserted position will be the one blocked, example target: 
```function (e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumpos,bit.bnot(0xff-POSITION_TO_ALLOW))==0
end
```

EFFECT_BECOME_LINKED: This effect, only useful under mr4, accept as value the zone that will be treated as a linked zone, even if there's no link monster

Place cards with official card number in TCG-OCG, Beta and Anime Cards in respective folders.
