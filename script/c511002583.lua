--Gorgonic Ritual
function c511002583.initial_effect(c)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCost(c511002583.cost)
	e3:SetTarget(c511002583.target)
	e3:SetOperation(c511002583.activate)
	c:RegisterEffect(e3)
end
function c511002583.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511002583.filter(c,e,tp)
	return c:IsRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002583.cfilter(c,e,tp,ft)
	return c:IsRace(RACE_ROCK) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true) 
		and (ft>1 or (aux.MZFilter(c,tp) and ft>0)) 
		and Duel.IsExistingMatchingCard(c511002583.filter,tp,LOCATION_GRAVE,0,2,c,e,tp)
end
function c511002583.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkcost=e:GetLabel()==1 and true or false
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if chkcost then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c511002583.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,ft)
		else
			return ft>0 and Duel.IsExistingMatchingCard(c511002583.filter,tp,LOCATION_GRAVE,0,2,c,e,tp)
		end
	end
	if chkcost then
		local g=Duel.SelectMatchingCard(tp,c511002583.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c511002583.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c511002583.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
