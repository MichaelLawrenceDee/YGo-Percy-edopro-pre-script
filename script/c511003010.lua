--超融合
function c511003010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c511003010.cost)
	e1:SetTarget(c511003010.target)
	e1:SetOperation(c511003010.activate)
	c:RegisterEffect(e1)
end
function c511003010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c511003010.filter1(c,e,tp,mg,f)
	return mg:IsExists(c511003010.filter2,1,c,e,tp,c,f)
end
function c511003010.filter2(c,e,tp,mc,f)
	local mg=Group.FromCards(c,mc)
	return Duel.IsExistingMatchingCard(c511003010.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,f)
end
function c511003010.ffilter(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function c511003010.mfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER
end
function c511003010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local g=Duel.GetMatchingGroup(c511003010.mfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESET_MSCHANGE)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetFusionMaterial(1-tp):Filter(Card.IsOnField,nil)
		mg1:Merge(mg2)
		local res=mg:IsExists(c511003010.filter1,1,nil,e,tp,mg1,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=mg3:IsExists(c511003010.filter1,1,nil,e,tp,mg3,mf)
			end
		end
		tc=g:GetFirst()
		while tc do
			tc:ResetEffect(RESET_MSCHANGE,RESET_EVENT)
			tc=g:GetNext()
		end
		return check
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c511003010.filter3(c,e,tp,mg)
	return not c:IsImmuneToEffect(e) and mg:IsExists(c511003010.filter4,1,c,e,tp,c)
end
function c511003010.filter4(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return not c:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(c511003010.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c511003010.filter0(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c511003010.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetFusionMaterial(tp):Filter(c511003010.filter0,nil,e)
	local g=Duel.GetMatchingGroup(c511003010.mfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local mtg1=Duel.GetFusionMaterial(tp):Filter(c511003010.filter0,nil,e)
	local mtg2=Duel.GetFusionMaterial(1-tp):Filter(c511003010.filter0,nil,e)
	mtg1:Merge(mtg2)
	local g1=mg1:Filter(c511003010.filter1,nil,e,tp,mtg1,nil)
	local mg2=nil
	local g2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		g2=mg2:Filter(c511003010.filter1,nil,e,tp,mg2,mf)
	end
	local tc=nil
	if g2~=nil and g2:GetCount()>0 and (g1:GetCount()==0 or Duel.SelectYesNo(tp,ce:GetDescription())) then
		local mf=ce:GetValue()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg2:FilterSelect(tp,c511003010.filter1,1,1,nil,e,tp,mg2,mf)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg2:FilterSelect(tp,c511003010.filter2,1,1,sg1,e,tp,sg1:GetFirst(),mf)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c511003010.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg1,mf)
		tc=sg:GetFirst()
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,sg1)
	elseif g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg1:FilterSelect(tp,c511003010.filter1,1,1,nil,e,tp,mtg1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mtg1:FilterSelect(tp,c511003010.filter2,1,1,sg1,e,tp,sg1:GetFirst(),nil)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c511003010.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg1,nil)
		tc=sg:GetFirst()
		tc:SetMaterial(sg1)
		Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
	if tc then
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(c511003010.sumsuc)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
	end
end
function c511003010.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
