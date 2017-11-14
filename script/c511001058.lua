--Parallel Unit
function c511001058.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001058.target)
	e1:SetOperation(c511001058.operation)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(511000189)
	e2:SetCondition(c511001058.con)
	e2:SetValue(c511001058.val)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
end
function c511001058.filter(c,e,tp)
	return c:GetLevel()>0 and c:IsFaceup()
end
function c511001058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c511001058.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511001058.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511001058.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c511001058.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c511001058.con(e)
	return e:GetHandler():GetFirstCardTarget()
end
function c511001058.val(e)
	return e:GetHandler():GetFirstCardTarget():GetLevel()
end
