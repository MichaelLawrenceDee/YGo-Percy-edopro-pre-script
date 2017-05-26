--Harmonic Geoglyph
function c511000744.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000744.target)
	e1:SetOperation(c511000744.activate)
	c:RegisterEffect(e1)
end
function c511000744.filter(c,e,tp)
	if not c:IsType(TYPE_SYNCHRO) or c:GetLevel()%2~=0 then return false end
	c511000744.Reset={}
	return Duel.IsExistingMatchingCard(c511000744.tmatfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
end
function c511000744.tmatfilter(c,e,tp,syncard)
	if not c:IsType(TYPE_TUNER) or not c:IsCanBeSynchroMaterial(syncard) or c:IsFacedown() then return false end
	local e2
	if c:IsHasEffect(EFFECT_SYNCHRO_LEVEL) then
		e2=c:GetCardEffect(EFFECT_SYNCHRO_LEVEL)
		local eff=e2:Clone()
		c:RegisterEffect(eff)
		e2:SetValue(2)
	else
		e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SYNCHRO_LEVEL)
		e2:SetValue(2)
		e2:SetReset(RESET_CHAIN)
		c:RegisterEffect(e2)
	end
	table.insert(c511000744.Reset,e2)
	local g=Duel.GetMatchingGroup(c511000744.matfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,e,syncard)
	g:AddCard(c)
	local res=syncard:IsSynchroSummonable(c,g)
	for i,eff in ipairs(c511000744.Reset) do
		eff:Reset()
	end
	c511000744.Reset={}
	return res
end
function c511000744.matfilter(c,e,syncard)
	if not c:IsType(TYPE_SYNCHRO) or not c:IsCanBeSynchroMaterial(syncard) or not c:IsLevelAbove(6) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2
	if c:IsHasEffect(EFFECT_SYNCHRO_LEVEL) then
		e2=c:GetCardEffect(EFFECT_SYNCHRO_LEVEL)
		local eff=e2:Clone()
		c:RegisterEffect(eff)
		e2:SetValue(2)
	else
		e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SYNCHRO_LEVEL)
		e2:SetValue(2)
		e2:SetReset(RESET_CHAIN)
		c:RegisterEffect(e2)
	end
	table.insert(c511000744.Reset,e1)
	table.insert(c511000744.Reset,e2)
	return true
end
c511000744.Reset={}
function c511000744.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c511000744.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511000744.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local g=Duel.GetMatchingGroup(c511001640.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mc=Duel.SelectMatchingCard(tp,c511000744.tmatfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc):GetFirst()
		local sg=Duel.GetMatchingGroup(c511000744.matfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,e,tc)
		sg:AddCard(mc)
		Duel.SynchroSummon(tp,tc,mc,sg)
	end
end
