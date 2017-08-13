--Iron Knight of Revolution
function c501000084.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c501000084.filter,3)
	--match kill
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATCH_KILL)
	e1:SetCondition(c501000084.con)
	c:RegisterEffect(e1)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c501000084.limit)
	c:RegisterEffect(e3)
end
function c501000084.filter(c)
	return c:IsLinkType(TYPE_EFFECT) and c:IsRace(RACE_MACHINE)
end
function c501000084.con(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if c:GetSequence()==0 or c:GetSequence()==4 then return false end
	local lc5=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
	local lc1=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
	local lc2=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	local lc3=Duel.GetFieldCard(tp,LOCATION_MZONE,3)
	local lc6=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
	if not lc5 or not lc1 or not lc2 or not lc3 or not lc6 then return false end
	local g5=lc5:GetMutualLinkedGroup()
	local g1=lc1:GetMutualLinkedGroup()
	local g2=lc2:GetMutualLinkedGroup()
	local g3=lc3:GetMutualLinkedGroup()
	if not g5 or not g1 or not g2 or not g3 or not g6 then return false end
	return g5:IsContains(lc1) and g1:IsContains(lc2) and g2:IsContains(lc3) and g3:IsContains(lc6)
end
function c501000084.limit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
