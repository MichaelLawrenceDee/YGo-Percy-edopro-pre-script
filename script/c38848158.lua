--イグナイト・ユナイト
function c38848158.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,38848158+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c38848158.target)
	e1:SetOperation(c38848158.activate)
	c:RegisterEffect(e1)
end
function c38848158.desfilter1(c,ft)
	return c:IsFaceup() and c:IsSetCard(0xc8) and (ft>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))
end
function c38848158.spfilter(c,e,tp)
	return c:IsSetCard(0xc8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c38848158.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c and c38848158.desfilter1(chkc,ft) end
	if chk==0 then
		return ft>-1 and Duel.IsExistingTarget(c38848158.desfilter1,tp,LOCATION_ONFIELD,0,1,c,ft)
			and Duel.IsExistingMatchingCard(c38848158.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c38848158.desfilter1,tp,LOCATION_ONFIELD,0,1,1,c,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c38848158.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c38848158.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
