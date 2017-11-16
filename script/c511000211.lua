--Reverse of Reverse
function c511000211.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetCondition(c511000211.condition)
	e1:SetTarget(c511000211.target)
	e1:SetOperation(c511000211.activate)
	c:RegisterEffect(e1)
end
function c511000211.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 
		and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c511000211.filter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c511000211.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000211.filter,tp,0,LOCATION_SZONE,1,nil) end
end
function c511000211.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c511000211.filter,tp,0,LOCATION_SZONE,nil)
	if sg:GetCount()>0 then
		Duel.ConfirmCards(tp,sg)
		local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
		c511000211[cid]={}
		local tc=sg:GetFirst()
		while tc do
			local te=tc:GetActivateEffect()
			if te then
				local e1=te:Clone()
				local con=te:GetCondition()
				local resetflag,resetcount=e:GetReset()
				e1:SetProperty(te:GetProperty()|EFFECT_FLAG_BOTH_SIDE)
				e1:SetCondition(c511000211.condition2(con))
				if resetflag and resetcount then
					e1:SetReset(resetflag|RESETS_STANDARD,resetcount)
				elseif resetflag then
					e1:SetReset(resetflag|RESETS_STANDARD)
				else
					e1:SetReset(RESETS_STANDARD)
				end
				tc:RegisterEffect(e1)
				table.insert(c511000211[cid],e1)
			end
			tc=sg:GetNext()
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EVENT_CHAINING)
		e2:SetCondition(c511000211.movecon)
		e2:SetOperation(c511000211.moveop)
		e2:SetLabel(cid)
		Duel.RegisterEffect(e2,tp)
	end
end
function c511000211.condition2(con)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return tp~=e:GetHandlerPlayer() and (not con or con(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c511000211.movecon(e,tp,eg,ep,ev,re,r,rp)
	for _,te in ipairs(c511000211[e:GetLabel()]) do
		if te==re then return true end
	end
	return false
end
function c511000211.moveop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.MoveToField(rc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		rc:CancelToGrave(false)
	end
end
