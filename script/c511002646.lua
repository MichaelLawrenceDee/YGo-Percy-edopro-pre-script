--Hell Vermin Mine
function c511002646.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002646.target)
	e1:SetOperation(c511002646.activate)
	c:RegisterEffect(e1)
	if not c511002646.global_check then
		c511002646.global_check=true
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetCountLimit(1)
		ge4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge4:SetOperation(c511002646.archchk)
		Duel.RegisterEffect(ge4,0)
	end
end
function c511002646.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002646.filter(c)
	return c:IsHell() and c:IsAbleToGrave()
end
function c511002646.desfilter(c)
	return c:IsAttackPos() and c:IsDestructable()
end
function c511002646.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511002646.filter,tp,LOCATION_HAND,0,1,nil) 
		and Duel.IsExistingMatchingCard(c511002646.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c511002646.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c511002646.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c511002646.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,c511002646.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g2:GetCount()>0 then
		Duel.HintSelection(g2)
		Duel.Destroy(g2,REASON_EFFECT)
	end
end
