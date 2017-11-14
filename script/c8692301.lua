--ジェムナイト・ジルコニア
function c8692301.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1047),aux.FilterBoolFunctionEx(Card.IsRace,RACE_ROCK))
end
c8692301.material_setcode={0x47,0x1047}
