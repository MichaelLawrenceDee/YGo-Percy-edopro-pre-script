--Doctor D
function c511000310.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c511000310.cost)
	e1:SetTarget(c511000310.target)
	e1:SetOperation(c511000310.activate)
	c:RegisterEffect(e1)
end
function c511000310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511000310.costfilter(c,e,tp,ft)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
		and (ft>0 or (aux.MZFilter(c,tp) and ft>-1))
		and Duel.IsExistingTarget(c511000310.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c511000310.spfilter(c,e,tp)
	return c:IsSetCard(0xc008) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511000310.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local chkcost=e:GetLabel()==1 and true or false
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511000310.spfilter(chkc,e,tp) end
	if chk==0 then
		if chkcost then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c511000310.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,ft)
		else
			return ft>0 and Duel.IsExistingTarget(c511000310.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	end
	if chkcost then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c511000310.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511000310.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511000310.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
