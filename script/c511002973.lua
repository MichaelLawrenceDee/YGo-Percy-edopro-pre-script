--Gladiator Beast Assault Fort
function c511002973.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511002973.condition)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c511002973.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c511002973.resetop2)
	c:RegisterEffect(e3)
	--activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetTarget(c511002973.actg)
	e6:SetOperation(c511002973.acop)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(511002973)
	c:RegisterEffect(e7)
	if not c511002973.global_check then
		c511002973.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(c511002973.resetop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHANGE_POS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002973.resetop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local sg
	if e:GetCode()==EVENT_CHANGE_POS then
		sg=eg:Filter(aux.AND(Card.IsHasEffect,Card.IsFacedown),nil,511002974)
	else
		sg=eg:Filter(Card.IsHasEffect,nil,511002974)
	end
	local tc=sg:GetFirst()
	while tc do
		local te=tc:GetCardEffect(511002974)
		local code=te:GetLabel()
		te:Reset()
		tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		tc=sg:GetNext()
	end
end
function c511002973.resetop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD,0,nil,511002974)
	local tc=g:GetFirst()
	while tc do
		local te=tc:GetCardEffect(511002974)
		local code=te:GetLabel()
		te:Reset()
		tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		tc=g:GetNext()
	end
end
function c511002973.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ep==tp and (a:IsSetCard(0x19) or (d and d:IsSetCard(0x19)))
end
function c511002973.desfilter(c)
	return not c:IsSetCard(0x19) or c:IsFacedown()
end
function c511002973.filter(c,tid)
	if c:IsHasEffect(511002974) or (c:IsHasEffect(511002973) and c:GetFieldID()<=tid) then return false end
	return c:IsFaceup() and c:IsSetCard(0x19) and c:GetSequence()<5
end
function c511002973.ovfilter(c)
	return c:IsSetCard(0x19) and c:IsType(TYPE_MONSTER)
end
function c511002973.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsDisabled() then
		local g=Duel.GetMatchingGroup(c511002973.desfilter,tp,LOCATION_ONFIELD,0,nil)
		Duel.Destroy(g,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(c511002973.filter,tp,LOCATION_SZONE,0,c,c:GetFieldID())
		local tc=sg:GetFirst()
		while tc do
			local code=tc:GetOriginalCode()
			tc:Recreate(511002974,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
			local og=Duel.SelectMatchingCard(tp,c511002973.ovfilter,tp,LOCATION_DECK,0,1,1,nil)
			if og:GetCount()>0 then
				Duel.Overlay(tc,og)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(511002974)
			e1:SetLabel(code)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD,0,nil,511002974)
		local tc=g:GetFirst()
		while tc do
			local te=tc:GetCardEffect(511002974)
			local code=te:GetLabel()
			te:Reset()
			tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
			tc=g:GetNext()
		end
	end
end
function c511002973.acfilter(c,tp)
	local te=c:GetActivateEffect()
	return c:IsCode(511002975) and te:IsActivatable(tp)
end
function c511002973.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:GetCount()>0 and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or g:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)>0) 
		and Duel.IsExistingMatchingCard(c511002973.acfilter,tp,0x13,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511002973.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c511002973.acfilter),tp,0x13,0,1,1,nil,tp):GetFirst()
		if tc then
			local tpe=tc:GetType()
			local te=tc:GetActivateEffect()
			local tg=te:GetTarget()
			local co=te:GetCost()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.ClearTargetCard()
			if tpe&TYPE_FIELD~=0 then
				local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
				if Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
					if fc then Duel.Destroy(fc,REASON_RULE) end
					fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
					if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				else
					Duel.GetFieldCard(tp,LOCATION_SZONE,5)
					if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				end
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if tpe&(TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
				tc:CancelToGrave(false)
			end
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			Duel.BreakEffect()
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(te)
			if etc then	
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
		end
	end
end
