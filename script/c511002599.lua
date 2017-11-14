--Ｎｏ.３９ 希望皇ホープ
function c511002599.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84013237,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(c511002599.atkcost)
	e1:SetOperation(c511002599.atkop)
	c:RegisterEffect(e1,false,1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c511002599.indes)
	c:RegisterEffect(e2)
	aux.CallToken(84013237)
end
c511002599.xyz_number=39
function c511002599.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511002599.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c511002599.indes(e,c)
	return not c:IsSetCard(0x48)
end
