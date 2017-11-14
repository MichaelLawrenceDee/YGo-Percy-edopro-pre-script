--Borrel Refrigeration
--ヴァレル・レフリジェレーション
--scripted by Larry126
function c511600029.initial_effect(c)
--equip
	aux.AddEquipProcedure(c,nil,c511600029.filter,c511600029.eqlimit,c511600029.cost,nil,c511600029.operation,nil)
end
function c511600029.cfilter(c)
	return c:IsLevelBelow(3) and c:IsSetCard(0x201)
end
function c511600029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511600029.cfilter,1,nil) end
	local rg=Duel.SelectReleaseGroup(tp,c511600029.cfilter,1,1,nil)
	Duel.Release(rg,REASON_COST)
end
function c511600029.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0x56f)
end
function c511600029.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsType(TYPE_LINK) and c:IsSetCard(0x56f)
end
function c511600029.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
		c:CancelToGrave()
		--
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(16617334,1))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCountLimit(1)
		e1:SetTarget(c511600029.efftg)
		e1:SetOperation(c511600029.effop)
		tc:RegisterEffect(e1)
	end
end
function c511600029.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511600029.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end