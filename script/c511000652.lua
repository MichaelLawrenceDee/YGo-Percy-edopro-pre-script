--Picador Fiend
function c511000652.initial_effect(c)
	--direct atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c511000652.dircon)
	c:RegisterEffect(e1)
end
function c511000652.dircon(e)
	return Duel.IsEnvironment(511000017)
end
