--Synchro Out
function c511002053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002053.target)
	e1:SetOperation(c511002053.activate)
	c:RegisterEffect(e1)
end
function c511002053.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
end
function c511002053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511002053.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511002053.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c511002053.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c511002053.mgfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:GetReason()&0x80008==0x80008 and c:GetReasonCard()==sync
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002053.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local sumtype=tc:GetSummonType()
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 and sumtype==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 
		and mg:GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c511002053.mgfilter),nil,e,tp,tc)==mg:GetCount()
		and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct==1) then
		Duel.BreakEffect()
		local fid=e:GetHandler():GetFieldID()
		local spc=mg:GetFirst()
		while spc do
			Duel.SpecialSummonStep(spc,0,tp,tp,false,false,POS_FACEUP)
			spc:RegisterFlagEffect(51102053,RESET_EVENT+0x1fe0000,0,1,fid)
			spc=mg:GetNext()
		end
		Duel.SpecialSummonComplete()
		mg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(mg)
		e1:SetCondition(c511002053.descon)
		e1:SetOperation(c511002053.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511002053.desfilter(c,fid)
	return c:GetFlagEffectLabel(51102053)==fid
end
function c511002053.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c511002053.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c511002053.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c511002053.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
