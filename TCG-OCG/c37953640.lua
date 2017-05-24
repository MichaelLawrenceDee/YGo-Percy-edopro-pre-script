--竜宮の白タウナギ
function c37953640.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(73941492+TYPE_SYNCHRO)
	e4:SetValue(aux.TargetBoolFunction(Card.IsRace,RACE_FISH))
	c:RegisterEffect(e4)
end
