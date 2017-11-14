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
	aux.CallToken(420)
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
