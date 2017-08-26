--アマゾネスの剣士
function c94004268.initial_effect(c)
	--reflect battle dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c94004268.damop)
	c:RegisterEffect(e1)
end
function c94004268.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=Duel.GetBattleDamage(tp)
	if dam>0 then
		Duel.ChangeBattleDamage(1-tp,Duel.GetBattleDamage(1-tp)+dam,false)
		Duel.ChangeBattleDamage(tp,0)
	end
end
