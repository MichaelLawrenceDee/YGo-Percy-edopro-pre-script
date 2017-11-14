--Parallel Port Armor
--パラレルポート・アーマー
--scripted by Larry126
function c511600025.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c511600025.filter,c511600025.eqlimit,nil,nil,c511600025.operation,nil)
	--second atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91499077,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511600025.atcon)
	e1:SetCost(c511600025.atkcost)
	e1:SetTarget(c511600025.atktg)
	e1:SetOperation(c511600025.atkop)
	c:RegisterEffect(e1)
end
function c511600025.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c511600025.cfilter(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToRemoveAsCost()
end
function c511600025.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c511600025.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c511600025.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c511600025.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c511600025.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511600025.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511600025.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511600025.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511600025.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c511600025.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511600025.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsType(TYPE_LINK)
end
function c511600025.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetValue(aux.tgoval)
		tc:RegisterEffect(e2)
	end
end
