--Big Return
function c511000699.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000699.target)
	e1:SetOperation(c511000699.activate)
	c:RegisterEffect(e1)
	if not c511000699.global_check then
		c511000699[0]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c511000699.checkop)
		Duel.RegisterEffect(ge1,0)
		c511000699.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c511000699.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511000699.clear(e,tp,eg,ep,ev,re,r,rp)
	c511000699[0]={}
end
function c511000699.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasProperty(EFFECT_FLAG_NO_TURN_RESET) then return end
	local _,ctmax,ctcode=re:GetCountLimit()
	if ctcode&(EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)>0 or ctmax~=1 then return end
	if rc:GetFlagEffect(511000699)==0 then
		c511000699[0][rc]={}
		rc:RegisterFlagEffect(511000699,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
	for _,te in ipairs(c511000699[0][rc]) do
		if te==re then return end
	end
	table.insert(c511000699[0][rc],re)
end
function c511000699.filter(c,tp)
	if c:GetFlagEffect(511000699)==0 or c:IsHasEffect(EFFECT_CANNOT_TRIGGER) then return false end
	local effs={Duel.GetPlayerEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	for _,te in ipairs(c511000699[0][c]) do
		for _,eff in ipairs(effs) do
			if type(eff:GetValue())=='function' then
				if eff:GetValue()(eff,te,tp) then return false end
			else return false end
		end
		return true
	end
	return false
end
function c511000699.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=e:GetHandler() and c511000699.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511000699.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511000699.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
end
function c511000699.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:GetFlagEffect(511000699)>0 then
		for _,te in ipairs(c511000699[0][tc]) do
			local _,ctmax,ctcode=te:GetCountLimit()
			te:SetCountLimit(ctmax,ctcode)
		end
	end
end
