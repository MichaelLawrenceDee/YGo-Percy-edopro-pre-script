--Garbage Collection
function c511001066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511001066.cost)
	e1:SetTarget(c511001066.target)
	e1:SetOperation(c511001066.activate)
	c:RegisterEffect(e1)
end
function c511001066.cfilter(c,e,tp)
	if not c:IsAbleToRemoveAsCost() or not c:IsRace(RACE_MACHINE) then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c511001066.filter(c,g,sg,e,tp)
	sg:AddCard(c)
	local res
	if sg:GetCount()<2 then
		res=g:IsExists(c511001066.filter,1,sg,g,sg,e,tp)
	else
		res=Duel.IsExistingTarget(c511001066.spfilter,tp,LOCATION_GRAVE,0,1,sg,e,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c511001066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c511001066.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return cg:IsExists(c511001066.filter,1,nil,cg,Group.CreateGroup(),e,tp) end
	local rg=Group.CreateGroup()
	while rg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Group.SelectUnselect(cg:Filter(c511001066.filter,rg,cg,rg,e,tp),rg,tp)
		if rg:IsContains(tc) then
			rg:RemoveCard(tc)
		else
			rg:AddCard(tc)
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c511001066.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511001066.spfilter(chkc,e,tp) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.IsPlayerAffectedByEffect(tp,69832741)) 
		and Duel.IsExistingTarget(c511001066.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511001066.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511001066.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
