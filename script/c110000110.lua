--Big Bang Blow
function c110000110.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c110000110.descon)
	e1:SetTarget(c110000110.destg)
	e1:SetOperation(c110000110.desop)
	c:RegisterEffect(e1)
	aux.CallToken(419)
end
function c110000110.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2
end
function c110000110.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g:GetCount(),g,1,0,0)
end
function c110000110.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local dg2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local dam1=dg1:GetSum(Card.GetAttack)
	local dam2=dg2:GetSum(Card.GetAttack)
	Duel.Damage(tp,dam1,REASON_EFFECT,true)
	Duel.Damage(1-tp,dam2,REASON_EFFECT,true)
	Duel.RDComplete()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(g,REASON_EFFECT)
	end
end
