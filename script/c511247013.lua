--痛恨の訴え
--fixed by MLD, not fully implementable
function c511247013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511247013.condition)
	e1:SetTarget(c511247013.target)
	e1:SetOperation(c511247013.activate)
	c:RegisterEffect(e1)
end
function c511247013.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c511247013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local sg=g:GetMaxGroup(Card.GetDefense)
	if chk==0 then return sg and sg:GetCount()>0 and sg:IsExists(Card.IsControlerCanBeChanged,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,sg,1,0,0)
end
function c511247013.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local sg=g:GetMaxGroup(Card.GetDefense):Filter(Card.IsControlerCanBeChanged,nil)
	if sg:GetCount()<=0 then return end
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		sg=sg:Select(tp,1,1,nil)
	end
	if Duel.GetTurnPlayer()==tp then
		Duel.GetControl(sg:GetFirst(),tp,PHASE_STANDBY)
	else
		Duel.GetControl(sg:GetFirst(),tp,PHASE_STANDBY,2)
	end
end
