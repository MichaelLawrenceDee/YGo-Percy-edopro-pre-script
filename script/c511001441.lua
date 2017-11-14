--Lightlow Protection
function c511001441.initial_effect(c)
	aux.AddEquipProcedure(c)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(511001441)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c511001441.descon)
	e3:SetTarget(c511001441.destg)
	e3:SetOperation(c511001441.desop)
	c:RegisterEffect(e3)
	aux.CallToken(419)
end
function c511001441.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec or not eg:IsContains(ec) then return false end
	local val=0
	if ec:GetFlagEffect(284)>0 then val=ec:GetFlagEffectLabel(284) end
	return ec:GetAttack()~=val and rp~=tp
end
function c511001441.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetEquipTarget(),1,0,0)
end
function c511001441.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c:GetEquipTarget(),REASON_EFFECT)
	end
end
