--Spirit Shield
function c511000116.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000116.cost)
	e1:SetTarget(c511000116.target)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c511000116.atkcon)
	e2:SetCost(c511000116.atkcost)
	e2:SetOperation(c511000116.atkop)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c511000116.descon)
	c:RegisterEffect(e3)
end
function c511000116.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c511000116.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local label=e:GetLabel()
	if chk==0 then
		if label==1 then e:SetLabel(0) end
		return true
	end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and c511000116.atkcon(e,tp,eg,ep,ev,re,r,rp) and (label~=1 or c511000116.atkcost(e,tp,eg,ep,ev,re,r,rp,0)) 
		and Duel.SelectYesNo(tp,aux.Stringid(81443745,1)) then
		e:SetOperation(c511000116.atkop)
		if label==1 then
			c511000116.atkcost(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetOperation(nil)
	end
end
function c511000116.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c511000116.descon(e)
	return not Duel.IsExistingMatchingCard(c511000116.filter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function c511000116.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c511000116.cfilter(c)
	return c:IsRace(RACE_FIEND+RACE_ZOMBIE) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c511000116.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000116.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c511000116.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c511000116.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
