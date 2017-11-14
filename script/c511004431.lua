--Exchanging Notes
--cleaned up by MLD
function c511004431.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511004431.condition)
	e1:SetTarget(c511004431.target)
	e1:SetOperation(c511004431.operation)
	c:RegisterEffect(e1)
end
function c511004431.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x526)
end
function c511004431.condition(e,tp,eg,ev,ep,re,r,rp)
	return Duel.IsExistingMatchingCard(c511004431.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511004431.target(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c511004431.operation(e,tp,eg,ev,ep,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		local g=Duel.GetOperatedGroup()
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,hg)
		local sg=hg:Select(tp,2,2,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		g:Merge(sg)
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetLabelObject(g1)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(c511004431.retop)
		Duel.RegisterEffect(e2,tp)
		local tg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
		local gc=tg:GetFirst()
		while gc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			gc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			gc:RegisterEffect(e2)
			gc=tg:GetNext()
		end
	end
end
function c511004431.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	g:DeleteGroup()
end
