--Air Sphere
function c511002289.initial_effect(c)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c511002289.con)
	c:RegisterEffect(e2)
	if not c511002289.global_check then
		c511002289.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002289.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002289.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002289.filter(c)
	return c:IsFaceup() and c:IsSphere()
end
function c511002289.con(e)
	return Duel.IsExistingMatchingCard(c511002289.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
