# Functions

Duel.RockPaperScissors([repeat = true]) - returns int (winner or PLAYER_NONE)

Duel.GetRandomNumber([int min = 0,]int max)

Card.GetCardEffect(card, int code) returns all the effect with that code applied on a card

Duel.GetPlayerEffect(int player, int code) returns all the effect with that code applied on the player

Duel.GetLinkedZone(int player) returns all the aviable linked zones a player has

Duel.GetLocationCountFromEx(int tp, int tp, group sg, card lc)  returns the number of free zones when sg are used as material for special summoning lc.

Duel.SelectDisableField(int player, int count, int s, int o, int filter[,bool all=false]), now it has an additional extra parameter when this parameter is set to true, the function will allow the selection of every zone on the field, from monster zone to pendulum zone

Duel.GetMasterRule() returns the current master rule

Card.SetUniqueOnField(Card c, int s, int o, int unique_code|function unique_function[, int unique_location=LOCATIOIN_ONFIELD]) now this function other than accepting the usual unique code, will work with functions too

# Effects:

EFFECT_CANNOT_SPECIAL_SUMMON now can accept the position as filter by putting it as the value, the inserted position will be the one blocked, example target: 
```
function (e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumpos,bit.bnot(0xff-POSITION_TO_ALLOW))==0
end
```

EFFECT_TUNER_MATERIAL_LIMIT: instead of using the EFFECT_SYNCHRO_MATERIAL_CUSTOM, when the monster only has a materials restriction, this can be used, in the target it accepts functions with these filters: (e,c) where e is the effect, in this case the LIMIT, and c is the generic non tuner material, when the function returns true the material will be able to be used

EFFECT_TUNE_MAGICIAN_X this effect is a filter for the xyz materials

EFFECT_BECOME_LINKED: This effect, only useful under mr4, accept as value the zone that will be treated as a linked zone, even if there's no link monster

##### Place cards with official card number in TCG-OCG, Beta and Anime Cards in respective folders.
