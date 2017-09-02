--Scripted by Eerie Code
--Bloom Prima the Melodious Choir
--fixed by MLD
function c700000029.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9b),1,99,function(c) return c:IsMelodiousSongtress(true) end)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c700000029.matcheck)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	if not c700000029.global_check then
		c700000029.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c700000029.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c700000029.material_setcode={0x9b,0x209b}
function c700000029.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c700000029.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*300)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
