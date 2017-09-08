--Kragen Spawn
function c511001337.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c511001337.destg)
	e1:SetOperation(c511001337.desop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511001337,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c511001337.sumcon)
	e2:SetTarget(c511001337.sumtg)
	e2:SetOperation(c511001337.sumop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c511001337.op)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c511001337.desfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsDestructable()
end
function c511001337.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511001337.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511001337.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511001337.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,g:GetFirst():GetControler(),0)
end
function c511001337.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Damage(tc:GetControler(),atk,REASON_EFFECT)
		end
	end
end
function c511001337.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
end
function c511001337.spfilter(c,e,tp)
	return c:IsCode(511001336,511001337) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001337.filterchk(c,g,sg,ft,ftex,ct,ect,ftt)
	local ct=ct-1
	if ftt<=0 then return false end
	local ftt=ftt-1
	if c:IsLocation(LOCATION_EXTRA) then
		if ftex<=0 or (ect and ect<=0) then return false end
		ftex=ftex-1
		if ect then ect=ect-1 end
		sg:AddCard(c)
		local res=ct<=0 or g:IsExists(c511001337.filterchk,1,sg,g,sg,ft,ftex,ct,ect,ftt)
		sg:RemoveCard(c)
		ftex=ftex+1
		if ect then ect=ect+1 end
		return res
	else
		if ft<=0 then return false end
		ft=ft-1
		sg:AddCard(c)
		local res=ct<=0 or g:IsExists(c511001337.filterchk,1,sg,g,sg,ft,ftex,ct,ect,ftt)
		sg:RemoveCard(c)
		ft=ft+1
		return res
	end
end
function c511001337.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c511001337.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	local ct=g:GetCount()
	local sg=Duel.GetMatchingGroup(c511001337.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ftex=Duel.GetLocationCountFromEx(tp)
	local ftt=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chk==0 then return ct>0 and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct<=1) 
		and sg:IsExists(c511001337.filterchk,1,nil,sg,Group.CreateGroup(),ft,ftex,ct,ect,ftt) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,nil)
end
function c511001337.sumop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=mg:GetCount()
	if ct<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c511001337.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	local sg=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ftex=Duel.GetLocationCountFromEx(tp)
	local ftt=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	while ct>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tempg=g:Filter(c511001337.filterchk,sg,g,sg,ft,ftex,ct,ect,ftt)
		if tempg:GetCount()<=0 then break end
		local tc=Group.SelectUnselect(tempg,sg,tp)
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
			ct=ct+1
			ftt=ftt+1
			if tc:IsLocation(LOCATION_EXTRA) then
				ftex=ftex+1
				if ect then ect=ect+1 end
			else
				ft=ft+1
			end
		else
			sg:AddCard(tc)
			ct=ct-1
			ftt=ftt-1
			if tc:IsLocation(LOCATION_EXTRA) then
				ftex=ftex-1
				if ect then ect=ect-1 end
			else
				ft=ft-1
			end
		end
	end
	if sg:GetCount()<=0 then return end
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local og=mg:Select(tp,1,1,nil)
		Duel.Overlay(tc,og)
		mg:Sub(og)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
