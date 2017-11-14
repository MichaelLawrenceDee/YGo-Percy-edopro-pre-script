--Underworld Resonance - Synchro Fusion
function c511002620.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002620.target)
	e1:SetOperation(c511002620.activate)
	c:RegisterEffect(e1)
end
function c511002620.fusfilter(c,e,tp,fe)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and Duel.IsExistingMatchingCard(c511002620.synfilter,tp,LOCATION_EXTRA,0,1,c,tp,c,fe)
end
function c511002620.synfilter(c,tp,fc,fe)
	local g=Duel.GetMatchingGroup(c511002620.filter,tp,LOCATION_MZONE,0,nil,fe,fc,c)
	return c:IsType(TYPE_SYNCHRO) and g:IsExists(c511002620.filterchk,1,nil,g,Group.CreateGroup(),tp,fc,c)
end
function c511002620.filter(c,e,fc,sc)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(sc) and c:IsCanBeFusionMaterial(fc) and (not e or not c:IsImmuneToEffect(e))
end
function c511002620.filterchk(c,g,sg,tp,fc,sc)
	sg:AddCard(c)
	local res
	if sg:GetCount()<fc.min_material_count then
		res=g:IsExists(c511002620.filterchk,1,sg,g,sg,tp,fc,sc)
	elseif sg:GetCount()<fc.max_material_count then
		res=c511002620.matchk(fc,sc,sg,tp)
			or g:IsExists(c511002620.filterchk,1,sg,g,sg,tp,fc,sc)
	else
		res=c511002620.matchk(fc,sc,sg,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c511002620.matchk(fc,sc,sg,e,tp)
	local t={}
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_MUST_BE_MATERIAL)
		e1:SetValue(function(c,sumtype,sc)return sumtype==SUMMON_TYPE_SYNCHRO end)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		t[tc]=e1
		tc=sg:GetNext()
	end
	local res=fc:CheckFusionMaterial(sg,nil,tp) and sc:IsSynchroSummonable(nil,sg) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>1
	tc=sg:GetFirst()
	while tc do
		t[tc]:Reset()
		tc=sg:GetNext()
	end
	return res
end
function c511002620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chk==0 then return (not ect or ect>=2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and Duel.IsExistingMatchingCard(c511002620.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c511002620.activate(e,tp,eg,ep,ev,re,r,rp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if Duel.IsPlayerAffectedByEffect(tp,29724053) or (ect and ect<2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fc=Duel.SelectMatchingCard(tp,c511002620.fusfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e):GetFirst()
	if not fc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c511002620.synfilter,tp,LOCATION_EXTRA,0,1,1,fc,tp,fc,e):GetFirst()
	local g=Duel.GetMatchingGroup(c511002620.filter,tp,LOCATION_MZONE,0,nil,e,fc,sc)
	local mat=Group.CreateGroup()
	while mat:GetCount()<fc.max_material_count do
		local cancel=mat:GetCount()>0 and c511002620.matchk(fc,sc,mat,tp)
		local sg=g:Filter(c511002620.filterchk,mat,g,mat,tp,fc,sc)
		if sg:GetCount()<=0 then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local tc=Group.SelectUnselect(sg,mat,tp,cancel,cancel)
		if not tc then break end
		if mat:IsContains(tc) then
			mat:RemoveCard(tc)
		else
			mat:AddCard(tc)
		end
	end
	fc:SetMaterial(mat)
	sc:SetMaterial(mat)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_SYNCHRO)
	Duel.BreakEffect()
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
	fc:CompleteProcedure()
	sc:CompleteProcedure()
end
