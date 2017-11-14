--召喚獣メガラニカ
function c48791583.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,86120751,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH))
end
