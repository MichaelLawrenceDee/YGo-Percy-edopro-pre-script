--恐撃
function c51099515.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c51099515.condition)
	e1:SetCost(c51099515.cost)
	e1:SetTarget(c51099515.target)
	e1:SetOperation(c51099515.activate)
	c:RegisterEffect(e1)
end
function c51099515.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c51099515.cfilter(c)
	if not c:IsType(TYPE_MONSTER) or not c:IsAbleToRemoveAsCost() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c51099515.filter(c,g,sg)
	sg:AddCard(c)
	local res
	if sg:GetCount()<2 then
		res=g:IsExists(c51099515.filter,1,sg,g,sg)
	else
		res=Duel.IsExistingTarget(c51099515.tfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c51099515.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c51099515.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return cg:IsExists(c51099515.filter,1,nil,cg,Group.CreateGroup()) end
	local rg=Group.CreateGroup()
	while rg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Group.SelectUnselect(cg:Filter(c51099515.filter,rg,cg,rg),rg,tp)
		if rg:IsContains(tc) then
			rg:RemoveCard(tc)
		else
			rg:AddCard(tc)
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c51099515.tfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:GetAttack()>0
end
function c51099515.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c51099515.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c51099515.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c51099515.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c51099515.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
