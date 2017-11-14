--coded by Lyris
--Flash Fang
--fixed by MLD
function c511007006.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511007006.target)
	e1:SetOperation(c511007006.activate)
	c:RegisterEffect(e1)
	if not c511007006.global_check then
		c511007006.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511007006.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511007006.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511007006.filter(c)
	return c:IsFaceup() and c:IsShark()
end
function c511007006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511007006.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c511007006.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c511007006.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(51107006,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DAMAGE)
		e2:SetOperation(c511007006.regop)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
	sg:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(sg)
	e2:SetCondition(c511007006.descon)
	e2:SetOperation(c511007006.desop)
	Duel.RegisterEffect(e2,tp)
end
function c511007006.regop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and Duel.GetAttackTarget()==nil then
		local c=e:GetHandler()
		c:SetFlagEffectLabel(51107006,c:GetFlagEffectLabel(51107006)+ev)
	end
end
function c511007006.desfilter(c,fid)
	return c:GetFlagEffectLabel(51107006)-fid>0
end
function c511007006.desopfilter(c,dam)
	return c:GetAttack()<dam
end
function c511007006.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local dg=g:Filter(c511007006.desfilter,nil,fid)
	if dg:GetCount()~=0 then
		local dam=0
		local tc=dg:GetFirst()
		while tc do
			dam=dam+(tc:GetFlagEffectLabel(51107006)-fid)
			tc=dg:GetNext()
		end
		return Duel.IsExistingMatchingCard(c511007006.desopfilter,tp,0,LOCATION_MZONE,1,nil,dam)
	else
		g:DeleteGroup()
		e:Reset()
		return false
	end
end
function c511007006.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local dg=g:Filter(c511007006.desfilter,nil,fid)
	g:DeleteGroup()
	local dam=0
	local tc=dg:GetFirst()
	while tc do
		dam=dam+(tc:GetFlagEffectLabel(51107006)-fid)
		tc=dg:GetNext()
	end
	local sg=Duel.GetMatchingGroup(c511007006.desopfilter,tp,0,LOCATION_MZONE,nil,dam)
	Duel.Destroy(sg,REASON_EFFECT)
end
