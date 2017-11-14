--泣き神の石像
function c5763020.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5763020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c5763020.spcost)
	e1:SetTarget(c5763020.sptg)
	e1:SetOperation(c5763020.spop)
	c:RegisterEffect(e1)
end
function c5763020.costfilter(c,ft)
	return c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true) 
		and (ft>0 or (aux.MZFilter(c,c:GetControler()) and ft>-1))
end
function c5763020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c5763020.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c5763020.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,ft)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c5763020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c5763020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
