--Buster Knuckle
function c110000109.initial_effect(c)
	--Piercing
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c110000109.atkup)
	c:RegisterEffect(e2)
	--sum limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetCondition(c110000109.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e5)
	aux.CallToken(419)
end
function c110000109.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_ARMOR)
end
function c110000109.atkup(e,c)
	return Duel.GetMatchingGroupCount(c110000109.filter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
function c110000109.operation(e)
	return Duel.GetMatchingGroupCount(c110000109.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==0
end
function c110000109.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c110000109.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
