--幻影融合
function c100000501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000501.target)
	e1:SetOperation(c100000501.activate)
	c:RegisterEffect(e1)
end
function c100000501.filter1(c,e,tp,mg,f)
	return mg:IsExists(c100000501.filter2,1,c,e,tp,c,f)
end
function c100000501.filter2(c,e,tp,mc,f)
	local mg=Group.FromCards(c,mc)
	return Duel.IsExistingMatchingCard(c100000501.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,f)
end
function c100000501.ffilter(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function c100000501.mfilter(c,e)
	return (c:IsSetCard(0x5008) or c:IsCode(27780618)) and c:IsLocation(LOCATION_SZONE) and (not e or not c:IsImmuneToEffect(e))
end
function c100000501.mttg(e,c)
	return (c:IsSetCard(0x5008) or c:IsCode(27780618))
end
function c100000501.mtval(e,c)
	if not c then return false end
	return true
end
function c100000501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_SZONE,0)
		e1:SetTarget(c100000501.mttg)
		e1:SetValue(c100000501.mtval)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local mg1=Duel.GetFusionMaterial(tp):Filter(c100000501.mfilter,nil)
		local res=mg1:IsExists(c100000501.filter1,1,nil,e,tp,mg1,nil)
		e1:Reset()
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=mg2:IsExists(c100000501.filter1,1,nil,e,tp,mg2,mf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100000501.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(c100000501.mttg)
	e1:SetValue(c100000501.mtval)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local mg1=Duel.GetFusionMaterial(tp):Filter(c100000501.mfilter,nil,e)
	local g1=mg1:Filter(c100000501.filter1,nil,e,tp,mg1,nil)
	local mg2=nil
	local g2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		g2=mg2:Filter(c100000501.filter1,nil,e,tp,mg2,mf)
	end
	local tc=nil
	if g2~=nil and g2:GetCount()>0 and (g1:GetCount()==0 or Duel.SelectYesNo(tp,ce:GetDescription())) then
		local mf=ce:GetValue()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg2:FilterSelect(tp,c100000501.filter1,1,1,nil,e,tp,mg2,mf)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg2:FilterSelect(tp,c100000501.filter2,1,1,sg1,e,tp,sg1:GetFirst(),mf)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c100000501.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg1,mf)
		tc=sg:GetFirst()
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,sg1)
	elseif g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg1:FilterSelect(tp,c100000501.filter1,1,1,nil,e,tp,mg1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg1:FilterSelect(tp,c100000501.filter2,1,1,sg1,e,tp,sg1:GetFirst(),nil)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c100000501.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg1,nil)
		tc=sg:GetFirst()
		tc:SetMaterial(sg1)
		Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
	if tc then
		tc:CompleteProcedure()
	end
end
