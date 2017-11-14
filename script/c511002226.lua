--Firebird, The Burning Skywing
function c511002226.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunctionEx(Card.IsRace,RACE_PYRO))
end
