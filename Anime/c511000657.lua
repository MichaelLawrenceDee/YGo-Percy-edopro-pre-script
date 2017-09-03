--Spacetime Trancendency
function c511000657.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000657.cost)
	e1:SetTarget(c511000657.target)
	e1:SetOperation(c511000657.activate)
	c:RegisterEffect(e1)
end
function c511000657.cfilter(c)
	if not c:IsRace(RACE_DINOSAUR) or not c:IsAbleToRemoveAsCost() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c511000657.filter(c,g,sg,e,tp)
	sg:AddCard(c)
	local res=Duel.IsExistingMatchingCard(c511000657.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,sg:GetCount())
		or g:IsExists(c6733059.filter,1,sg,g,sg,e,tp)
	sg:RemoveCard(c)
	return res
end
function c511000657.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==lv
end
function c511000657.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c511000657.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroupCount(c511000657.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return cg:IsExists(c511000657.filter,1,nil,cg,Group.CreateGroup(),e,tp)
			and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.IsPlayerAffectedByEffect(tp,69832741)) end
	local rg=Group.CreateGroup()
	local tc
	::start::
		local cancel=rg:GetCount()>0 and Duel.IsExistingMatchingCard(c511000657.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,rg:GetCount())
		local g=cg:Filter(c511000657.filter,rg,cg,rg,e,tp)
		if g:GetCount()<=0 then goto jump end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=Group.SelectUnselect(g,rg,tp,cancel,cancel)
		if not tc then goto jump end
		if rg:IsContains(tc) then
			rg:RemoveCard(tc)
		else
			rg:AddCard(tc)
		end
		goto start
	::jump::
	Duel.SetTargetParam(rg:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c511000657.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or lv<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000657.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
