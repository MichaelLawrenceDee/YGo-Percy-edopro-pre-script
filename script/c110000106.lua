--Over Boost
function c110000106.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c) return c:IsType(TYPE_ARMOR) end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c110000106.regcon)
	e2:SetOperation(c110000106.regop)
	c:RegisterEffect(e2)
	aux.CallToken(419)
end
function c110000106.regcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return not Duel.GetAttackTarget() and a:IsType(TYPE_ARMOR) and a:IsControler(tp) and a:GetEffectCount(EFFECT_DIRECT_ATTACK)==1 
		and e:GetHandler():GetFlagEffect(110000106)==0
		and Duel.IsExistingMatchingCard(aux.NOT(Card.IsHasEffect),tp,0,LOCATION_MZONE,1,nil,EFFECT_IGNORE_BATTLE_TARGET)
end
function c110000106.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(110000106,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetCondition(c110000106.descon)
	e1:SetOperation(c110000106.desop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c110000106.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(110000106)>0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c110000106.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,110000106)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
