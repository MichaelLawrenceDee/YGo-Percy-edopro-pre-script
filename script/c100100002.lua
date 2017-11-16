--Ｓｐ－遺言状
function c100100002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100100002.cost)
	e1:SetTarget(c100100002.target)
	e1:SetOperation(c100100002.activate)
	c:RegisterEffect(e1)
	if not c100100002.global_check then
		c100100002.global_check=true
		c100100002[0]=true
		c100100002[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c100100002.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c100100002.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100100002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and tc:IsCanRemoveCounter(tp,0x91,5,REASON_COST) end	 
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	tc:RemoveCounter(tp,0x91,5,REASON_COST)	
end
function c100100002.cfilter(c,tp)
	return c:IsControler(tp) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c100100002.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c100100002.cfilter,1,nil,tp) then
		c100100002[tp]=true
	end
	if eg:IsExists(c100100002.cfilter,1,nil,1-tp) then
		c100100002[1-tp]=true
	end
end
function c100100002.clear(e,tp,eg,ep,ev,re,r,rp)
	c100100002[0]=false
	c100100002[1]=false
end
function c100100002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c100100002[tp] then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function c100100002.activate(e,tp,eg,ep,ev,re,r,rp)
	if c100100002.spcon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(85602018,0)) then
		c100100002.spop(e,tp,eg,ep,ev,re,r,rp,true)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(c100100002.spcon)
		e1:SetOperation(c100100002.spop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c100100002.spfilter(c,e,tp)
	return c:IsAttackBelow(1500) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100100002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return c100100002[tp] and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100100002.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c100100002.spop(e,tp,eg,ep,ev,re,r,rp,nohint)
	if not nohint then
		Duel.Hint(HINT_CARD,0,85602018)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100100002.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
