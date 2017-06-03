--B－バスター・ドレイク
function c77411244.initial_effect(c)
	aux.AddUnionProcedure(c,c77411244.unfilter)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c77411244.efilter)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c77411244.thcon)
	e2:SetTarget(c77411244.thtg)
	e2:SetOperation(c77411244.thop)
	c:RegisterEffect(e2)
end
function c77411244.unfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c77411244.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_SPELL)
end
function c77411244.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c77411244.thfilter(c)
	return c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function c77411244.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77411244.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77411244.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77411244.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end