--Judge Man (DM)
--Scripted by edo9300
function c511000567.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000567,2))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(0xff)
	e1:SetCondition(c511000567.condition)
	e1:SetCost(c511000567.cost)
	e1:SetTarget(c511000567.target)
	e1:SetOperation(c511000567.operation)
	c:RegisterEffect(e1)
	aux.CallToken(300)
end
c511000567.dm=true
function c511000567.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDeckMaster()
end
function c511000567.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.GetFlagEffect(tp,511000567+1)==0 end
	Duel.PayLPCost(tp,1000)
	if Duel.GetTurnPlayer()==tp then
		Duel.RegisterFlagEffect(tp,511000567+1,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	else
		Duel.RegisterFlagEffect(tp,511000567+1,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
	end
end
function c511000567.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511000567.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end