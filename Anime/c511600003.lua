--ファイナル・ギアス
--Final Geas
function c511600003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_TOGRAVE)
	e1:SetCondition(c511600003.condition)
	e1:SetTarget(c511600003.target)
	e1:SetOperation(c511600003.activate)
	c:RegisterEffect(e1)	
	if not c511600003.global_check then
		c511600003.global_check=true
		c511600003[0]=false
		c511600003[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c511600003.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c511600003.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511600003.cfilter(c)
	return c:IsFaceup() and c:GetLevel()>0
end

function c511600003.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local g=Duel.GetMatchingGroup(c511600003.cfilter,tc:GetPreviousControler(),LOCATION_MZONE,0,nil)
		if g:GetCount()==0 then 
			c511600003[tc:GetPreviousControler()]=true
		else 
			local sg=g:GetMaxGroup(Card.GetLevel)
			local tc2=sg:GetFirst()
			if tc:GetPreviousLevelOnField()>=tc2:GetLevel() and tc:IsPreviousLocation(LOCATION_MZONE) then
			c511600003[tc:GetPreviousControler()]=true
			end
		end
		tc=eg:GetNext()
	end
end
function c511600003.clear(e,tp,eg,ep,ev,re,r,rp)
	c511600003[0]=false
	c511600003[1]=false
end
function c511600003.condition(e,tp,eg,ep,ev,re,r,rp)
	return c511600003[0] and c511600003[1]
end
function c511600003.filter(c)
	if not c:IsType(TYPE_MONSTER) or not c:IsAbleToRemove() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c511600003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600003.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c511600003.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if g:FilterCount(Card.IsControler,nil,1-tp)==0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_MZONE+LOCATION_GRAVE)
	elseif g:FilterCount(Card.IsControler,nil,tp)==0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_MZONE+LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),PLAYER_ALL,LOCATION_GRAVE)
	end
end
function c511600003.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLocation(LOCATION_REMOVED) and c:GetLevel()>0
end
function c511600003.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511600003.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(c511600003.spfilter,nil,e,tp)
		if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(511500003,0)) then
			Duel.BreakEffect()
			local sg=og:GetMaxGroup(Card.GetLevel)
			if sg:GetCount()>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,1,1,nil)
			end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
