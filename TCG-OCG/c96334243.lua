--Sea Monster of Theseus
--Scripted by Eerie Code
function c96334243.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsType,TYPE_TUNER),2)
end
