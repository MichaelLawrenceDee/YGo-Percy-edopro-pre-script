--Doodlebook - Uh Uh Uh!
function c511009135.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511009135.condition)
	e1:SetOperation(c511009135.activate)
	c:RegisterEffect(e1)
end
function c511009135.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x518)
end
function c511009135.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
