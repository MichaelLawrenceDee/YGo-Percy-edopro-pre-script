--錬金術の研究成果
function c100000246.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000246.cost)
	e1:SetTarget(c100000246.target)
	e1:SetOperation(c100000246.activate)
	c:RegisterEffect(e1)
end
function c100000246.condition(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,57116033)
end
function c100000246.cfilter(c,e,tp)
	if not c:IsCode(57116033) or not c:IsAbleToGraveAsCost() then return false end
	local ct=c:GetSequence()<5 and 1 or 0
	local g=Duel.GetMatchingGroup(c100000246.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	return g:GetCount()>2 and aux.SelectUnselectGroup(g,e,tp,3,3,aux.ChkfMMZ(1-ct),0)
end
function c100000246.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c)
end
function c100000246.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c100000246.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c100000246.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	local ct=tg:GetFirst():GetSequence()<5 and 1 or 0
	local g=Duel.GetMatchingGroup(c100000246.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tg)
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.ChkfMMZ(1-ct),1,tp,HINTMSG_TOREMOVE)
	Duel.SendtoGrave(tg,REASON_COST)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c100000246.filter(c,e,tp)
	return c:IsCode(33776734) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000246.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c100000246.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c100000246.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c100000246.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
