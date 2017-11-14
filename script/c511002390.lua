--Power Off
function c511002390.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002390.target)
	e1:SetOperation(c511002390.activate)
	c:RegisterEffect(e1)
	aux.CallToken(419)
end
function c511002390.filter(c,e,tp)
	local mg=c:GetMaterial()
	return c:IsFaceup() and c:IsType(TYPE_PLUS) and c:IsType(TYPE_MINUS) and c:IsAbleToGrave() and mg:GetCount()>0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=mg:GetCount()+1 and not mg:IsExists(c511002390.mgfilter,1,nil,e,tp,c)
end
function c511002390.mgfilter(c,e,tp,card)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:GetReason()&REASON_COST==REASON_COST and c:GetReasonCard()==card
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002390.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511002390.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511002390.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c511002390.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c511002390.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c511002390.mgfilter),nil,e,tp,tc)==ct then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
