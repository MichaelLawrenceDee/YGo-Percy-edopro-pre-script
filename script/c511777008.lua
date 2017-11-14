--奇策
--Nitwit Outwit
--fixed by MLD
function c511777008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511777008.condition)
	e1:SetTarget(c511777008.target)
	e1:SetOperation(c511777008.activate)
	c:RegisterEffect(e1)
end
function c511777008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c511777008.filter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c511777008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511777008.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c511777008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c511777008.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local atk=tc:GetAttack()
	if atk<0 then atk=0 end
	if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetOperation(c511777008.rdop)
		e1:SetLabel(atk)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511777008.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,math.max(0,Duel.GetBattleDamage(tp)-e:GetLabel()))
end
