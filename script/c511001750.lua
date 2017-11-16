--Emergency Evasion
function c511001750.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511001750.condition)
	e1:SetTarget(c511001750.target)
	e1:SetOperation(c511001750.activate)
	c:RegisterEffect(e1)
end
function c511001750.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c511001750.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c511001750.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if g:GetCount()>0 and Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local rg=Duel.GetOperatedGroup()
		rg:KeepAlive()
		local tc=rg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(511001750,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			tc=rg:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetLabelObject(rg)
		e1:SetCondition(c511001750.drcon)
		e1:SetOperation(c511001750.drop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511001750.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerCanDraw(tp,1)
end
function c511001750.retfilter(c,tp,tpe)
	return c:GetFlagEffect(511001750)>0 and c:IsLocation(LOCATION_REMOVED) and c:IsType(tpe) 
		and (Duel.GetLocationCount(tp,c:GetPreviousLocation())>0 or c:IsType(TYPE_FIELD))
end
function c511001750.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	c:RegisterFlagEffect(511001749,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.Hint(HINT_CARD,0,511001750)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and tc then
		Duel.ConfirmCards(1-tp,tc)
		local tpe=tc:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		if tpe<=0 then return end
		if g:IsExists(c511001750.retfilter,1,nil,tp,tpe) then
			local rg=g:FilterSelect(tp,c511001750.retfilter,1,1,nil,tp,tpe)
			Duel.HintSelection(rg)
			local rc=rg:GetFirst()
			if rc:GetType()&TYPE_FIELD==TYPE_FIELD then
				local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
				if Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
					if fc then Duel.Destroy(fc,REASON_RULE) end
					fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
					if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				else
					fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
					if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				end
			end
			if rc:IsPreviousLocation(LOCATION_MZONE) then
				Duel.ReturnToField(rc)
			else
				Duel.MoveToField(rc,tp,tp,rc:GetPreviousLocation(),rc:GetPreviousPosition(),true)
			end
		end
		Duel.ShuffleHand(tp)
	end
end
