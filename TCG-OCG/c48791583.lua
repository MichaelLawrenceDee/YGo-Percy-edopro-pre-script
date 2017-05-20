--召喚獣メガラニカ
function c48791583.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(true,true,86120751,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH))
end
