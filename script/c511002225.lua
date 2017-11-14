--Bombing Beast Fire Bomber 
function c511002225.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunctionEx(Card.IsRace,RACE_PYRO))
end
