--Quick Rush
function c511000333.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000333.target)
	e1:SetOperation(c511000333.operation)
	c:RegisterEffect(e1)
end
function c511000333.filter(c)
	return c:GetAttackAnnouncedCount()==0 and c:IsFaceup() and c:IsLevelBelow(4)
end
function c511000333.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) or Duel.IsExistingTarget(c511000333.filter,tp,LOCATION_MZONE,0,1,nil) end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76922029,0))
	if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c511000333.filter,tp,LOCATION_MZONE,0,1,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(22093873,0),aux.Stringid(43047672,1))
	elseif Duel.IsPlayerCanDraw(tp,1) then
		Duel.SelectOption(tp,aux.Stringid(22093873,0))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(43047672,1))
		op=1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.SelectTarget(tp,c511000333.filter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function c511000333.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
	else
		local tc=Duel.GetFirstTarget()
		if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
		local d=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.CalculateDamage(tc,d)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
		end
	end
end
