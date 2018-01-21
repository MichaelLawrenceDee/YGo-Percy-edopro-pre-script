--Briar Transplant
function c511000789.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000789.target)
	e1:SetOperation(c511000789.activate)
	c:RegisterEffect(e1)
end
function c511000789.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c511000789.activate(e,tp,eg,ep,ev,re,r,rp)
	if c511000789.rmcon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(51316684,0)) then
		c511000789.rmop(e,tp,eg,ep,ev,re,r,rp,true)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(c511000789.rmcon)
		e1:SetOperation(c511000789.rmop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511000789.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler() or nil
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c511000789.rmop(e,tp,eg,ep,ev,re,r,rp,nohint)
	if not nohint then
		Duel.Hint(HINT_CARD,0,511000789)
	end
	local c=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler() or nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
