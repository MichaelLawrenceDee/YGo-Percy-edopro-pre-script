--Wonderbeat Elf
--scripted by:urielkama
--fixed by MLD
function c511004108.initial_effect(c)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetCondition(c511004108.facon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c511004108.val)
	c:RegisterEffect(e2)
	if not c511004108.global_check then
		c511004108.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511004108.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511004108.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511004108.facon(e)
	return e:GetHandler()GetAttackableTarget():GetCount()>0
end
function c511004108.filter(c)
	return c:IsFaceup() and c:IsElf()
end
function c511004108.val(e,c)
	return Duel.GetMatchingGroupCount(c511004108.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
end
