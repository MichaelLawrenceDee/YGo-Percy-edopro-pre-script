--遺言状
function c85602018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c85602018.target)
	e1:SetOperation(c85602018.activate)
	c:RegisterEffect(e1)
	if not c85602018.global_check then
		c85602018.global_check=true
		c85602018[0]=true
		c85602018[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c85602018.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c85602018.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c85602018.cfilter(c,tp)
	return c:IsControler(tp) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c85602018.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c85602018.cfilter,1,nil,tp) then
		c85602018[tp]=true
	end
	if eg:IsExists(c85602018.cfilter,1,nil,1-tp) then
		c85602018[1-tp]=true
	end
end
function c85602018.clear(e,tp,eg,ep,ev,re,r,rp)
	c85602018[0]=false
	c85602018[1]=false
end
function c85602018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c85602018[tp] then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function c85602018.activate(e,tp,eg,ep,ev,re,r,rp)
	if c85602018.spcon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(85602018,0)) then
		c85602018.spop(e,tp,eg,ep,ev,re,r,rp,true)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(c85602018.spcon)
		e1:SetOperation(c85602018.spop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c85602018.spfilter(c,e,tp)
	return c:IsAttackBelow(1500) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c85602018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return c85602018[tp] and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c85602018.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c85602018.spop(e,tp,eg,ep,ev,re,r,rp,nohint)
	if not nohint then
		Duel.Hint(HINT_CARD,0,85602018)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c85602018.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
