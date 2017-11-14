--ジェムナイト・エメラル
function c69243722.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69243722,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c69243722.cost)
	e1:SetTarget(c69243722.target)
	e1:SetOperation(c69243722.operation)
	c:RegisterEffect(e1)
end
function c69243722.costfilter(c,ft)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsAbleToRemoveAsCost() 
		and (ft>0 or c:GetSequence()<5)
end
function c69243722.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>-1 and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c69243722.costfilter,tp,LOCATION_MZONE,0,1,c,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c69243722.costfilter,tp,LOCATION_MZONE,0,1,1,c,ft)
	rg:AddCard(c)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c69243722.filter(c,e,tp)
	return c:IsSetCard(0x1047) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c69243722.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c69243722.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c69243722.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c69243722.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c69243722.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
