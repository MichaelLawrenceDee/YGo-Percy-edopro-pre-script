--Skiel Guard (Anime)
function c513000176.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c513000176.sdcon)
	c:RegisterEffect(e1)
	--another card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c513000176.rdacondition)
	e2:SetOperation(c513000176.rdaoperation)
	c:RegisterEffect(e2)
	if not c513000176.global_check then
		c513000176.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c513000176.archchk)
		Duel.RegisterEffect(ge1,0)
	end
end
function c513000176.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c513000176.cfilter(c)
	return c:IsFaceup() and c:IsInfinity()
end
function c513000176.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c513000176.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c513000176.rdacondition(e,tp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp)
end
function c513000176.rdaoperation(e,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.NegateAttack()
	end
end