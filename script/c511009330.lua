--Gathering Light
function c511009330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c511009330.cost)
	e2:SetTarget(c511009330.tg)
	e2:SetOperation(c511009330.op)
	c:RegisterEffect(e2)
end
function c511009330.crfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c511009330.filter,tp,LOCATION_MZONE,0,1,c)
end
function c511009330.cfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsRace(RACE_DRAGON) or c:IsSetCard(0xc2))
end
function c511009330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009330.crfilter,tp,LOCATION_MZONE,0,1,nil,tp) 
		and Duel.IsExistingMatchingCard(c511009330.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c511009330.crfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c511009330.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Overlay(e:GetHandler(),g)
end
function c511009330.filter(c)
	return c:IsFaceup() and c511009330.cfilter(c)
end
function c511009330.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c511009330.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local ag=Duel.SelectMatchingCard(tp,c511009330.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=ag:GetFirst()
	if tc then
		local og=c:GetOverlayGroup()
		if not og then return end
		local ct=og:FilterCount(c511009330.cfilter,nil)
		Duel.HintSelection(ag)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(ct*400)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511009330.atkcon)
	e2:SetOperation(c511009330.atkop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
function c511009330.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c511009330.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(511009330)==0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.NegateAttack()
		e:Reset()
	end
	c:RegisterFlagEffect(511009330,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,0)
end
