--Heat Crystals
function c511002360.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511002360.cost)
	e1:SetTarget(c511002360.target)
	e1:SetOperation(c511002360.activate)
	c:RegisterEffect(e1)
end
function c511002360.cfilter(c)
	if not c:IsAttribute(ATTRIBUTE_FIRE) or not c:IsAbleToRemoveAsCost() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c511002360.filter(c,g,sg,e,tp)
	sg:AddCard(c)
	local res
	if sg:GetCount()<2 then
		res=g:IsExists(c511002360.filter,1,sg,g,sg,e,tp)
	else
		res=Duel.GetLocationCountFromEx(tp,tp,sg)>0 
			and Duel.IsExistingMatchingCard(c511002360.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,sg,e,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c511002360.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_FUSION) and c:IsSetCard(0x3008) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c511002360.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c511002360.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return cg:IsExists(c511002360.filter,1,nil,cg,Group.CreateGroup(),e,tp) end
	local rg=Group.CreateGroup()
	while rg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Group.SelectUnselect(cg:Filter(c511002360.filter,rg,cg,rg,e,tp),rg,tp)
		if rg:IsContains(tc) then
			rg:RemoveCard(tc)
		else
			rg:AddCard(tc)
		end
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c511002360.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511002360.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c511002360.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511002360.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
