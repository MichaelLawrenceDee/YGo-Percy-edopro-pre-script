--魂喰らいの魔刀
function c5371656.initial_effect(c)
	aux.AddEquipProcedure(c,0,c5371656.filter,nil,c5371656.cost,c5371656.target,c5371656.operation)
end
function c5371656.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(3)
end
function c5371656.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c5371656.rfilter(c)
	local tpe=c:GetType()
	return bit.band(tpe,TYPE_NORMAL)~=0 and bit.band(tpe,TYPE_TOKEN)==0 and c:IsReleasable()
end
function c5371656.target(e,tp,eg,ep,ev,re,r,rp,tc,chk)
	local label=e:GetLabel()
	e:SetLabel(0)
	if chk==0 then return true end
	if label==1 then
		local rg=Duel.GetMatchingGroup(c5371656.rfilter,tp,LOCATION_MZONE,0,tc)
		Duel.Release(rg,REASON_COST)
		Duel.SetTargetParam(rg:GetCount()*1000)
	else
		Duel.SetTargetParam(0)
	end
end
function c5371656.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
