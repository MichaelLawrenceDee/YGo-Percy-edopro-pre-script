--Scripted by Eerie Code
--Ancient Gear Chaos Fusion
--fixed by MLD
function c700000034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCost(c700000034.cost)
	e1:SetTarget(c700000034.target)
	e1:SetOperation(c700000034.activate)
	c:RegisterEffect(e1)
end
function c700000034.cfilter(c)
	return c:IsCode(24094653) and c:IsAbleToGraveAsCost()
end
function c700000034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c700000034.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c700000034.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c700000034.matfilter(c,e,tp,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
end
function c700000034.spfilter(c,e,tp,rg)
	if not c:IsType(TYPE_FUSION) or not c:IsSetCard(0x7) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then return false end
	local minc=c.min_material_count
	local maxc=c.max_material_count
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not minc then return false end
	local mg=Duel.GetMatchingGroup(c700000034.matfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,c)
	return rg:IsExists(c700000034.rmfilterchk,1,nil,mg,rg,c,minc,maxc,Group.CreateGroup(),ft,tp)
end
function c700000034.rmfilter(c)
	if c:GetSummonLocation()~=LOCATION_EXTRA or not c:IsPreviousLocation(LOCATION_MZONE) or not c:IsAbleToRemove() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c700000034.rmfilterchk(c,mg,rg,fc,minc,maxc,sg,ft,tp)
	sg:AddCard(c)
	local res
	local ftchk
	if c:IsLocation(LOCATION_MZONE) then ftchk=true ft=ft+1 end
	if sg:GetCount()<minc then
		res=rg:IsExists(c700000034.rmfilterchk,1,sg,mg,rg,fc,minc,maxc,sg,ft,tp)
	elseif sg:GetCount()<maxc then
		res=rg:IsExists(c700000034.rmfilterchk,1,sg,mg,rg,fc,minc,maxc,sg,ft,tp) 
			or mg:IsExists(c700000034.matchk,1,sg,mg,sg,sg:GetCount(),Group.CreateGroup(),fc,ft,tp)
	else
		res=mg:IsExists(c700000034.matchk,1,sg,mg,sg,sg:GetCount(),Group.CreateGroup(),fc,ft,tp)
	end
	if ftchk then ft=ft-1 end
	sg:RemoveCard(c)
	return res
end
function c700000034.matchk(c,mg,sg,ct,matg,fc,ft,tp)
	if ft<ct or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1) then return false end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and (c29724053[tp]-1)
	if ect and matg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)>ect then return false end
	sg:AddCard(c)
	matg:AddCard(c)
	local res
	if matg:GetCount()<ct then
		res=mg:IsExists(c700000034.matchk,1,sg,mg,sg,ct,matg,fc,ft,tp)
	else
		res=fc:CheckFusionMaterial(matg,nil,tp) and matg:IsExists(function(mc) return fc:CheckFusionMaterial(matg,mc) end,ct,nil)
	end
	sg:RemoveCard(c)
	matg:RemoveCard(c)
	return res
end
function c700000034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(c700000034.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and Duel.IsExistingMatchingCard(c700000034.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fg=Duel.SelectMatchingCard(tp,c700000034.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rg)
	Duel.ConfirmCards(1-tp,fg:GetFirst())
	Duel.SetTargetCard(fg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c700000034.activate(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFirstTarget()
	local rg=Duel.GetMatchingGroup(c700000034.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if not fc or not fc:IsRelateToEffect(e) or not c700000034.spfilter(fc,e,tp,rg) then return false end
	local minc=fc.min_material_count
	local maxc=fc.max_material_count
	local mg=Duel.GetMatchingGroup(c700000034.matfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,fc)
	local rsg=Group.CreateGroup()
	local matg=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	while rsg:GetCount()<maxc do
		local cancel=rsg:GetCount()>0 and mg:IsExists(c700000034.matchk,1,rsg,mg,rsg,rsg:GetCount(),matg,fc,ft,tp)
		local g=rg:Filter(c700000034.rmfilterchk,rsg,mg,rg,fc,minc,maxc,rsg,ft,tp)
		if g:GetCount()<=0 then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Group.SelectUnselect(g,rsg,tp,cancel,cancel)
		if not tc then break end
		if rsg:IsContains(tc) then
			rsg:RemoveCard(tc)
			if tc:IsLocation(LOCATION_MZONE) then
				ft=ft-1
			end
		else
			rsg:AddCard(tc)
			if tc:IsLocation(LOCATION_MZONE) then
				ft=ft+1
			end
		end
	end
	local ct=Duel.Remove(rsg,POS_FACEUP,REASON_EFFECT)
	if ct<rsg:GetCount() then return end
	mg:Sub(rsg)
	while matg:GetCount()<ct do
		local g=mg:Filter(c700000034.matchk,matg,mg,matg,ct,matg,fc,ft,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Group.SelectUnselect(g,matg,tp)
		if matg:IsContains(tc) then
			matg:RemoveCard(tc)
		else
			matg:AddCard(tc)
		end
	end
	local mc=matg:GetFirst()
	while mc do
		Duel.SpecialSummonStep(mc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		mc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		mc:RegisterEffect(e3)
		mc=matg:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	fc:SetMaterial(matg)
	Duel.SendtoGrave(matg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
end
