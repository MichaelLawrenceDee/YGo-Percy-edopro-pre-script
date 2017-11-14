--H・C ダブル・ランス
function c511002760.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(511001225)
	e2:SetOperation(c511002760.tgval)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c511002760.tgval(e,c)
	return c:IsSetCard(0x206f)
end
