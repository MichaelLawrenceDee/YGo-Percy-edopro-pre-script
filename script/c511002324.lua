--Angel Tear
function c511002324.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511002324.cost)
	e1:SetTarget(c511002324.target)
	e1:SetOperation(c511002324.activate)
	c:RegisterEffect(e1)
end
function c511002324.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511002324.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c511002324.spfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002324.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and Duel.IsExistingMatchingCard(c511002324.spfilter,tp,LOCATION_GRAVE,0,1,sg,e,tp)
end
function c511002324.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkcost=e:GetLabel()==1 and true or false
	local rg=Duel.GetMatchingGroup(c511002324.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if chkcost then
			e:SetLabel(0)
			return ft>-4 and rg:GetCount()>3 and aux.SelectUnselectGroup(rg,e,tp,4,4,c511002324.rescon,0)
		else
			return ft>0 and Duel.IsExistingMatchingCard(c511002324.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	end
	if chkcost then
		local g=aux.SelectUnselectGroup(rg,e,tp,4,4,c511002324.rescon,1,tp,HINTMSG_REMOVE)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c511002324.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c511002324.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
