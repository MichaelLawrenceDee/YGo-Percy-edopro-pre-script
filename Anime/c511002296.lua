--Air Barrier
function c511002296.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c511002296.condition)
	e1:SetOperation(c511002296.activate)
	c:RegisterEffect(e1)
	if not c511002296.global_check then
		c511002296.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002296.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002296.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002296.cfilter(c)
	return c:IsFaceup() and c:IsSphere()
end
function c511002296.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002296.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511002296.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,LOCATION_MZONE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
