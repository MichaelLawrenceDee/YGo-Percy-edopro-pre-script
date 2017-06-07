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
function c511002324.costfilter(c)
	if not c:IsRace(RACE_FAIRY) or not c:IsAbleToRemoveAsCost() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c511002324.spfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002324.filter(c,g,sg,e,tp)
	sg:AddCard(c)
	local res
	if sg:GetCount()<4 then
		res=g:IsExists(c511002324.filter,1,sg,g,sg,e,tp)
	else
		res=Duel.IsExistingMatchingCard(c511002324.spfilter,tp,LOCATION_GRAVE,0,1,sg,e,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c511002324.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c511002324.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return cg:IsExists(c511002324.filter,1,nil,cg,Group.CreateGroup(),e,tp) end
	local rg=Group.CreateGroup()
	while rg:GetCount()<4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Group.SelectUnselect(cg:Filter(c511002324.filter,rg,cg,rg,e,tp),rg,tp)
		if rg:IsContains(tc) then
			rg:RemoveCard(tc)
		else
			rg:AddCard(tc)
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c511002324.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.IsPlayerAffectedByEffect(tp,69832741))  
		and Duel.IsExistingMatchingCard(c511002324.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
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
