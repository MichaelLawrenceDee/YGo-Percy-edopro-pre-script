--Kaiser Sea Horse (DM)
--Scripted by edo9300
function c511000575.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(c511000575.condition)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(0xff)
	e2:SetCondition(c511000575.con)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	e2:SetValue(0x10001)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DECREASE_TRIBUTE_SET)
	c:RegisterEffect(e3)
	aux.CallToken(300)
end
c511000575.dm=true
function c511000575.condition(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c511000575.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDeckMaster()
end	
