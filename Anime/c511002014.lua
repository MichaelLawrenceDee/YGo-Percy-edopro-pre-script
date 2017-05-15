--Supreme Thunder Star Raijin
function c511002014.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.FConditionMix(true,true,c511002014.ffilter1,c511002014.ffilter2)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	if not c511002014.global_check then
		c511002014.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002014.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002014.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002014.ffilter1(c)
	return c420.IsEarth(c,true)
end
function c511002014.ffilter2(c)
	return c420.IsSky(c,true)
end
