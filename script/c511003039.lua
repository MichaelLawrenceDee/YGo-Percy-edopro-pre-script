--エクシーズ・リモーラ
function c511003039.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c511003039.spcon)
	e1:SetOperation(c511003039.spop)
	c:RegisterEffect(e1)
end
function c511003039.cfilter(c,tp)
	return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c511003039.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511003039.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c511003039.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=Duel.SelectMatchingCard(tp,c511003039.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local mg=g:GetFirst():GetOverlayGroup()
	local ct=mg:GetCount()
	Duel.SendtoGrave(mg,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(511001225)
	e1:SetValue(ct)
	e1:SetOperation(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	c:RegisterEffect(e1)
end
