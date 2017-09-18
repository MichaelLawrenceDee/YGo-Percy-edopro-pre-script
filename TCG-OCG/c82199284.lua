--霞の谷のファルコン
function c82199284.initial_effect(c)
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(c82199284.atcost)
	e1:SetOperation(c82199284.atop)
	c:RegisterEffect(e1)
end
function c82199284.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c82199284.atop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsAttackCostPaid()~=2 and e:GetHandler():IsLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.GetMatchingGroup(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,e:GetHandler()):SelectUnselect(Group.CreateGroup(),tp,Duel.IsAttackCostPaid()==0, Duel.IsAttackCostPaid()==0)
		if tc then
			Duel.SendtoHand(tc,nil,REASON_COST)
			Duel.AttackCostPaid()
		else
			Duel.AttackCostPaid(2)
		end
	end
end
