--Over Tuning
function c511001606.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001606.target)
	e1:SetOperation(c511001606.activate)
	c:RegisterEffect(e1)
	if not c511001606.global_check then
		c511001606.global_check=true
		c511001606[0]=true
		c511001606[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c511001606.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetCountLimit(1)
		ge4:SetOperation(c511001606.clear)
		Duel.RegisterEffect(ge4,0)
	end
end
function c511001606.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c511001606.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c511001606.cfilter,1,nil,tp) then
		c511001606[tp]=true
	end
	if eg:IsExists(c511001606.cfilter,1,nil,1-tp) then
		c511001606[1-tp]=true
	end
end
function c511001606.clear(e,tp,eg,ep,ev,re,r,rp)
	c511001606[0]=false
	c511001606[1]=false
end
function c511001606.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c511001606[tp] then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function c511001606.activate(e,tp,eg,ep,ev,re,r,rp)
	if c511001606.spcon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(30241314,0)) then
		c511001606.spop(e,tp,eg,ep,ev,re,r,rp,true)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(c511001606.spcon)
		e1:SetOperation(c511001606.spop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511001606.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001606.spcon(e,tp,eg,ep,ev,re,r,rp)
	return c511001606[tp] and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511001606.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function c511001606.spop(e,tp,eg,ep,ev,re,r,rp,nohint)
	if not nohint then
		Duel.Hint(HINT_CARD,0,511001606)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511001606.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
