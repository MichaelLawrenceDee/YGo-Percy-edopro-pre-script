--Spinning Wheel Spindle
function c511001420.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001420.target)
	e1:SetOperation(c511001420.activate)
	c:RegisterEffect(e1)
end
function c511001420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c511001420.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetCondition(c511001420.retcon)
			e1:SetOperation(c511001420.retop)
			e1:SetLabel(0)
			e1:SetLabelObject(g:GetFirst())
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
			Duel.RegisterEffect(e1,tp)
			local descnum=tp==c:GetOwner() and 0 or 1
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetDescription(aux.Stringid(4931121,descnum))
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e3:SetCode(1082946)
			e3:SetLabelObject(e1)
			e3:SetOwnerPlayer(tp)
			e3:SetOperation(c511001420.reset)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
			c:RegisterEffect(e3)
		end
	end
end
function c511001420.reset(e,tp,eg,ep,ev,re,r,rp)
	c511001420.retop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function c511001420.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511001420.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=e:GetLabel()+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==3 then
		if tc and tc:IsLocation(LOCATION_GRAVE) then
			Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
		end
		if re then re:Reset() end
	end
end
