--Hellfire Boatwatcher, Ghost Charon
function c511000806.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetOperation(c511000806.synop)
	c:RegisterEffect(e1)
	--grave synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	e3:SetLabel(511000806)
	e3:SetValue(c511000806.synval)
	c:RegisterEffect(e3)
end
function c511000806.synval(e,c,sc)
	if c:IsLocation(LOCATION_GRAVE) and c:IsAttribute(ATTRIBUTE_DARK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(511000806)
		e1:SetTarget(c511000806.synchktg)
		c:RegisterEffect(e1)
		return true
	else return false end
end
function c511000806.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==511000806 then return true end
	end
	return false
end
function c511000806.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=true
		if sg:GetCount()>=2 or (not tg:IsExists(c511000806.chk2,1,c) and not ntg:IsExists(c511000806.chk2,1,c) 
			and not sg:IsExists(c511000806.chk2,1,c)) then return false end
		local ttg=tg:Filter(c511000806.chk2,nil)
		local nttg=ntg:Filter(c511000806.chk2,nil)
		local trg=tg:Clone()
		local ntrg=ntg:Clone()
		trg:Sub(ttg)
		ntrg:Sub(nttg)
		return res,trg,ntrg
	else
		return sg:GetCount()<2
	end
end
function c511000806.synopfilter(c)
	if not c:IsLocation(LOCATION_GRAVE) or not c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()~=511000806 then return false end
	end
	return true
end
function c511000806.synop(e,tg,ntg,sg,lv,sc,tp)
	local tsg=sg:Clone()
	if tsg:IsExists(c511000806.synopfilter,1,nil) then
		return sg:GetCount()==2 and tsg:GetFirst():IsAttribute(ATTRIBUTE_DARK),false
	else
		return true,false
	end
end
