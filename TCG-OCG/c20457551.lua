--鋼核収納
function c20457551.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x1d))
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c20457551.atkcon)
	e3:SetTarget(c20457551.atktg)
	e3:SetValue(c20457551.atkval)
	c:RegisterEffect(e3)
	--destroy sub
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c20457551.desreptg)
	c:RegisterEffect(e4)
end
function c20457551.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler():GetEquipTarget():GetBattleTarget()
end
function c20457551.atktg(e,c)
	return c==e:GetHandler():GetEquipTarget():GetBattleTarget()
end
function c20457551.atkval(e,c)
	return e:GetHandler():GetEquipTarget():GetLevel()*-100
end
function c20457551.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:GetEquipTarget():IsReason(REASON_REPLACE) and Duel.GetCurrentPhase()==PHASE_END end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return true
	else return false end
end
