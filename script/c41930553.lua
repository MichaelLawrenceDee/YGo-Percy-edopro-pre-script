--暗黒の瘴気
function c41930553.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c41930553.target)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(41930553,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c41930553.rmtg)
	e2:SetOperation(c41930553.rmop)
	c:RegisterEffect(e2)
end
function c41930553.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c41930553.rmtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return true end
	if c41930553.rmtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(41930553,0)) then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c41930553.rmop)
		c41930553.rmtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c41930553.cfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsDiscardable()
end
function c41930553.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function c41930553.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c41930553.rfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(41930553)==0
		and Duel.IsExistingMatchingCard(c41930553.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(c41930553.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c41930553.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(41930553,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c41930553.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,c41930553.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if cg:GetCount()==0 then return end
	Duel.SendtoGrave(cg,REASON_EFFECT+REASON_DISCARD)
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
