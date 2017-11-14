--Album of Memories
function c511009332.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511009332.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c511009332.atkcon)
	e2:SetOperation(c511009332.atkop)
	c:RegisterEffect(e2)
end
function c511009332.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and c511009332.atkcon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,94) then
		e:GetHandler():RegisterFlagEffect(511009332,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
		e:SetOperation(function(e) if not e:GetHandler():IsRelateToEffect(e) then return end Duel.NegateAttack() end)
	else
		e:SetOperation(nil)
	end
end
function c511009332.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(511009332)<Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xa9)
end
function c511009332.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.NegateAttack()
		c:RegisterFlagEffect(511009332,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end
