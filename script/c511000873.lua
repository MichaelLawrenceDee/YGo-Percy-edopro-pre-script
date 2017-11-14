--Star Excursion
function c511000873.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511000873.rmcon)
	e1:SetTarget(c511000873.rmtg)
	e1:SetOperation(c511000873.rmop)
	c:RegisterEffect(e1)
end
function c511000873.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return at and a:IsType(TYPE_SYNCHRO) and at:IsType(TYPE_SYNCHRO)
end
function c511000873.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if chk==0 then return at and a:IsAbleToRemove() and at:IsAbleToRemove() end
	local g=Group.FromCards(a,at)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c511000873.rmop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	local g=Group.FromCards(a,at)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			if oc:IsControler(tp) then
				oc:RegisterFlagEffect(511000873,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,0,4)
			else
				oc:RegisterFlagEffect(511000873,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,0,4)
			end
			oc=og:GetNext()
		end
		if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		og:KeepAlive()
		local c=e:GetHandler()
		local res
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		if Duel.GetTurnPlayer()~=tp then
			res=4
			e1:SetLabel(-1)
		else
			res=3
			e1:SetLabel(0)
		end
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,res)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetCondition(c511000873.retcon)
		e1:SetOperation(c511000873.retop)
		Duel.RegisterEffect(e1,tp)
		local descnum=tp==c:GetOwner() and 0 or 1
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetDescription(aux.Stringid(4931121,descnum))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(1082946)
		e2:SetLabelObject(e1)
		e2:SetOwnerPlayer(tp)
		e2:SetOperation(c511000873.reset)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,res)
		c:RegisterEffect(e2)
	end
end
function c511000873.reset(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then e:Reset() return end
	c511000873.retop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function c511000873.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c511000873.retfilter,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return Duel.GetTurnPlayer()~=tp end
end
function c511000873.retfilter(c)
	return c:GetFlagEffect(511000873)~=0
end
function c511000873.retop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct>=3 then
		local g=e:GetLabelObject()
		local sg=g:Filter(c511000873.retfilter,nil)
		g:DeleteGroup()
		local tc=sg:GetFirst()
		while tc do
			Duel.ReturnToField(tc)
			tc:SetStatus(STATUS_SUMMON_TURN+STATUS_FORM_CHANGED,false)
			tc=sg:GetNext()
		end
		if re then re:Reset() end
	end
end
