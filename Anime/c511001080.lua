--Cookmate Lionion
function c511001080.initial_effect(c)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetTarget(c511001080.bttg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function c511001080.bttg(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x512)
end
