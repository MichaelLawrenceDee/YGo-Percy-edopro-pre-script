--Amazoness Call
function c511001904.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511001904.condition)
	e1:SetTarget(c511001904.target)
	e1:SetOperation(c511001904.activate)
	c:RegisterEffect(e1)
end
function c511001904.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4)
end
function c511001904.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511001904.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511001904.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function c511001904.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511001904.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511001904.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c511001904.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c511001904.mgfilter(c,e,tp,fusc)
	return c:IsLocation(LOCATION_GRAVE) and c:GetReason()&0x40008==0x40008 
		and c:GetReasonCard()==fusc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001904.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local mg=tc:GetMaterial()
	local sumtype=tc:GetSummonType()
	local mg1=mg:Filter(Card.IsControler,nil,tp)
	local mg2=mg:Filter(Card.IsControler,nil,1-tp)
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 and sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION and mg:GetCount()>0
		and mg:FilterCount(aux.NecroValleyFilter(c511001904.mgfilter),nil,e,tp,tc)==mg:GetCount()
		and mg1:GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE) and mg2:GetCount()<=Duel.GetLocationCount(1-tp,LOCATION_MZONE) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummon(mg2,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
