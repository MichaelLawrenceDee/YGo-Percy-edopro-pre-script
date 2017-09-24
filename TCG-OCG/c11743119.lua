--ユニオン・ライダー
function c11743119.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11743119,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c11743119.eqcon)
	e1:SetTarget(c11743119.eqtg)
	e1:SetOperation(c11743119.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,c11743119.eqcon,c11743119.eqval,c11743119.equipop,e1)
end
function c11743119.eqval(ec,c,tp)
	return ec:IsControler(1-tp) and ec:IsType(TYPE_UNION)
end
function c11743119.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c11743119.eqfilter,nil)
	return g:GetCount()==0
end
function c11743119.eqfilter(c)
	return c:GetFlagEffect(11743119)~=0 
end
function c11743119.filter(c)
	return c:IsType(TYPE_UNION) and c:IsAbleToChangeControler()
end
function c11743119.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c11743119.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c11743119.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c11743119.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c11743119.equipop(c,e,tp,tc)
	aux.EquipByEffectAndLimitRegister(c,e,tp,tc,11743119)
end
function c11743119.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c11743119.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
