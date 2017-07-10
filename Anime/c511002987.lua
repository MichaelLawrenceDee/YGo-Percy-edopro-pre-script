--Earthbound Prisoner Ground Keeper
function c511002987.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c511002987.indtg)
	e1:SetValue(c511002987.indval)
	c:RegisterEffect(e1)
	if not c511002987.global_check then
		c511002987.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002987.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002987.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002987.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsEarthbound()
end
function c511002987.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511002987.filter,1,nil,tp) end
	return true
end
function c511002987.indval(e,c)
	return c511002987.filter(c,e:GetHandlerPlayer())
end
