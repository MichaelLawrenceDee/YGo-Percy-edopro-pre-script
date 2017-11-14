--百機夜工
function c7030340.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c7030340.target)
	e1:SetOperation(c7030340.activate)
	c:RegisterEffect(e1)
end
function c7030340.filter1(c)
	return c:IsSetCard(0x26) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c7030340.filter2(c,sg)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not sg:IsContains(c)
end
function c7030340.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7030340.filter2(chkc) end
	local rg=Duel.GetMatchingGroup(c7030340.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return rg:GetCount()>0 and Duel.IsExistingTarget(c7030340.filter2,tp,LOCATION_MZONE,0,1,nil,rg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c7030340.filter2,tp,LOCATION_MZONE,0,1,1,nil,rg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0)
end
function c7030340.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c7030340.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
	if ct>0 and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetCount()*200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
