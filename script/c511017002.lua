--V・HERO トリニティー
function c511017002.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x5008),2,3)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511017002.regcon)
	e1:SetOperation(c511017002.regop)
	c:RegisterEffect(e1)
end
c511017002.material_setcode={0x8,0x5008}
function c511017002.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and e:GetHandler():GetMaterialCount()==3
end
function c511017002.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(c:GetBaseAttack()*2)
	c:RegisterEffect(e1)
end
