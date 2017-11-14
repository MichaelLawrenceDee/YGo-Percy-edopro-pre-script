--Comic Field
function c511002919.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c511002919.destg)
	e4:SetValue(c511002919.desval)
	c:RegisterEffect(e4)
	if not c511002919.global_check then
		c511002919.global_check=true
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetCountLimit(1)
		ge4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge4:SetOperation(c511002919.archchk)
		Duel.RegisterEffect(ge4,0)
	end
end
function c511002919.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002919.dfilter(c)
	return c:IsFaceup() and c:IsOnField() and c:IsReason(REASON_BATTLE) and c:IsComicsHero()
end
function c511002919.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:FilterCount(c511002919.dfilter,nil)==1 end
	Duel.Hint(HINT_CARD,0,511002919)
	local g=eg:Filter(c511002919.dfilter,nil)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(500)
	tc:RegisterEffect(e1)
	return true
end
function c511002919.desval(e,c)
	return c:IsFaceup() and c:IsOnField() and c:IsReason(REASON_BATTLE) and c:IsComicsHero()
end
