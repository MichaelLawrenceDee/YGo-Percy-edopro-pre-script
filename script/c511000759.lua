--Instant Tune
function c511000759.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,51100759+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c511000759.target)
	e1:SetOperation(c511000759.activate)
	c:RegisterEffect(e1)
end
function c511000759.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) 
		and Duel.IsExistingMatchingCard(c511000759.matfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler(),c)
end
function c511000759.matfilter(c,mc,sc)
	local g=Group.FromCards(c,mc)
	local e1=Effect.CreateEffect(mc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_TUNER)
	e1:SetReset(RESET_CHAIN)
	mc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(1)
	mc:RegisterEffect(e2)
	local res=sc:IsSynchroSummonable(nil,g)
	e1:Reset()
	e2:Reset()
	return res
end
function c511000759.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c511000759.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511000759.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_TUNER)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local g=Duel.GetMatchingGroup(c511000759.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=Duel.SelectMatchingCard(tp,c511000759.matfilter,tp,LOCATION_MZONE,0,1,1,nil,c,sc)
		sg:AddCard(c)
		Duel.SynchroSummon(tp,sc,nil,sg)
	end
end
