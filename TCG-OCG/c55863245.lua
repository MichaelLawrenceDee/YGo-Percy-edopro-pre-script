--たつのこ
function c55863245.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c55863245.efilter)
	c:RegisterEffect(e2)
	--hand synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(c55863245.syncon)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	e3:SetLabel(55863245)
	e3:SetValue(c55863245.synval)
	c:RegisterEffect(e3)
end
function c55863245.syncon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c55863245.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c55863245.synval(e,c,sc)
	if c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(55863245)
		e1:SetTarget(c55863245.synchktg)
		c:RegisterEffect(e1)
		return true
	else return false end
end
function c55863245.chk(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()~=55863245 then return false end
	end
	return true
end
function c55863245.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==55863245 then return true end
	end
	return false
end
function c55863245.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=true
		if sg:IsExists(c55863245.chk,1,c) or (not tg:IsExists(c55863245.chk2,1,c) and not ntg:IsExists(c55863245.chk2,1,c) 
			and not sg:IsExists(c55863245.chk2,1,c)) then return false end
		local trg=tg:Filter(c55863245.chk,nil)
		local ntrg=ntg:Filter(c55863245.chk,nil)
		return res,trg,ntrg
	else
		return true
	end
end
