--ファイヤー・ウォール
function c94804055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c94804055.target)
	c:RegisterEffect(e1)
	--quick
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94804055,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c94804055.atkcon)
	e2:SetCost(c94804055.atkcost)
	e2:SetTarget(c94804055.atktg)
	e2:SetOperation(c94804055.atkop)
	c:RegisterEffect(e2)
	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c94804055.mtcon)
	e3:SetOperation(c94804055.mtop)
	c:RegisterEffect(e3)
end
function c94804055.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c94804055.atktg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and c94804055.atkcon(e,tp,eg,ep,ev,re,r,rp) and c94804055.atkcost(e,tp,eg,ep,ev,re,r,rp,0) 
		and c94804055.atktg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(94804055,1)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c94804055.atkop)
		c94804055.atkcost(e,tp,eg,ep,ev,re,r,rp,1)
		c94804055.atktg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c94804055.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c94804055.cfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c94804055.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94804055.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c94804055.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c94804055.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c94804055.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
function c94804055.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c94804055.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(94804055,2)) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
