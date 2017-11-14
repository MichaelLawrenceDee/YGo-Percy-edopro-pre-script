--Active Guard
function c110000103.initial_effect(c)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetTargetRange(1,0)
	e1:SetLabel(0)
	e1:SetValue(c110000103.damval)
	c:RegisterEffect(e1)
	--copy	
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e1)
	e2:SetOperation(c110000103.regop)
	c:RegisterEffect(e2)
	aux.CallToken(419)
end
function c110000103.damval(e,re,val,r,rp,rc)
	if val~=0 then
		if e:GetHandler():GetFlagEffect(110000103)==0 then
			e:SetLabel(1)
		end
		return 0
	else return val end
end
function c110000103.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=e:GetLabelObject():GetLabel()
	if val==1 then
		c:RegisterFlagEffect(110000103,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(c)
		e1:SetCondition(c110000103.descon)
		e1:SetOperation(c110000103.desop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		e:GetLabelObject():SetLabel(0)
	end
end
function c110000103.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(110000103)>0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c110000103.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,110000103)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
