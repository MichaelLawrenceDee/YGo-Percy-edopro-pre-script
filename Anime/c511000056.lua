--Double Ripple
function c511000056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000056.target)
	e1:SetOperation(c511000056.activate)
	c:RegisterEffect(e1)
end
function c511000056.filter1(c,ntg,tp)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsType(TYPE_TUNER) and ntg:IsExists(c511000056.chkfilter,1,nil,ntg,Group.FromCards(c),tp)
end
function c511000056.chkfilter(c,g,sg,tp)
	sg:AddCard(c)
	local res=(Duel.GetLocationCountFromEx(tp,tp,sg)>1 and sg:CheckWithSumEqual(Card.GetLevel,7,sg:GetCount(),sg:GetCount()))
		or g:IsExists(c511000056.chkfilter,1,sg,g,sg,tp)
	sg:RemoveCard(c)
	return res
end
function c511000056.filter2(c)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsType(TYPE_TUNER) 
end
function c511000056.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511000056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local nt=Duel.GetMatchingGroup(c511000056.filter2,tp,LOCATION_MZONE,0,nil)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and (not ect or ect>=2) 
		and Duel.IsExistingMatchingCard(c511000056.filter1,tp,LOCATION_MZONE,0,1,nil,nt,tp) 
		and Duel.IsExistingMatchingCard(c511000056.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,2403771)
		and	Duel.IsExistingMatchingCard(c511000056.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,25862681)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c511000056.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil and ect<2 then return end
	local nt=Duel.GetMatchingGroup(c511000056.filter2,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c511000056.filter1,tp,LOCATION_MZONE,0,1,1,nil,nt,tp)
	local tc=g:GetFirst()
	if tc then
		local sg=Group.FromCards(tc)
		::start::
			local cancel=sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>1 and sg:CheckWithSumEqual(Card.GetLevel,7,sg:GetCount(),sg:GetCount())
			local mg=nt:Filter(c511000056.chkfilter,sg,g,sg,tp)
			if mg:GetCount()<=0 then goto jump end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc2=Group.SelectUnselect(mg,sg,tp,cancel,cancel)
			if not tc2 then goto jump end
			if tc==tc2 then goto start end
			if sg:IsContains(tc2) then
				sg:RemoveCard(tc2)
			else
				sg:AddCard(tc2)
			end
			goto start
		::jump::
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local g1=Duel.GetMatchingGroup(c511000056.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,2403771)
		local g2=Duel.GetMatchingGroup(c511000056.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,25862681)
		if g1:GetCount()>0 and g2:GetCount()>0 and Duel.GetLocationCountFromEx(tp)>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g2:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			Duel.BreakEffect()
			local sgc=sg1:GetFirst()
			while sgc do
				Duel.SpecialSummonStep(sgc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
				sgc=sg1:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end
