--彼岸の巡礼者 ダンテ
function c18386170.initial_effect(c)
	c:EnableReviveLimit()
	c18386170.min_material_count=3
	c18386170.max_material_count=3
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c18386170.fscon)
	e1:SetOperation(c18386170.fsop)
	c:RegisterEffect(e1)
	--special summon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c18386170.tgval)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetCost(c18386170.drcost)
	e4:SetTarget(c18386170.drtg)
	e4:SetOperation(c18386170.drop)
	c:RegisterEffect(e4)
	--handes
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(c18386170.hdcon)
	e5:SetTarget(c18386170.hdtg)
	e5:SetOperation(c18386170.hdop)
	c:RegisterEffect(e5)
end
function c18386170.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
function c18386170.cfilter(c)
	return c:IsSetCard(0xb1) and c:IsAbleToGraveAsCost()
end
function c18386170.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18386170.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c18386170.cfilter,1,1,REASON_COST,nil)
end
function c18386170.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c18386170.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c18386170.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)) or c:IsReason(REASON_BATTLE)
end
function c18386170.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c18386170.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c18386170.ffilter(c,fc)
	return (c:IsFusionSetCard(0xb1) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c18386170.filterchk1(c,mg,g2,ct,chkf)
	local tg
	if g2==nil or g2:GetCount()==0 then tg=Group.CreateGroup() else tg=g2:Clone() end
	local g=mg:Clone()
	tg:AddCard(c)
	g:RemoveCard(c)
	local ctc=ct+1
	if ctc==3 then
		return c18386170.filterchk2(tg,chkf)
	else
		return g:IsExists(c18386170.filterchk1,1,nil,g,tg,ctc,chkf)
	end
end
function c18386170.filterchk2(g,chkf)
	if g:IsExists(aux.TuneMagFusFilter,1,nil,g,chkf) then return false end
	local fs=false
	if g:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return g:IsExists(c18386170.namechk,1,nil,g) and (fs or chkf==PLAYER_NONE)
end
function c18386170.filterchk(c,tp,mg,sg,fc)
	sg:AddCard(c)
	mg:RemoveCard(c)
	local rg=Group.CreateGroup()
	if not c:IsHasEffect(511002961) then
		rg=mg:Filter(function(rc) return rc:IsFusionCode(c:GetFusionCode()) and not rc:IsHasEffect(511002961) end,nil)
		mg:Sub(rg)
	end
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if sg:IsExists(aux.TuneMagFilter,1,c,eff[i],f) then
				mg:Merge(rg)
				return false
			end
			local sg2=sg:Filter(function(c) return not aux.TuneMagFilterFus(c,eff[i],f) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	local res
	if sg:GetCount()<3 then
		res=mg:IsExists(c18386170.filterchk,1,sg,tp,mg,sg,fc)
	else
		res=Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0 and (not aux.FCheckAdditional or aux.FCheckAdditional(tp,sg,fc))
	end
	sg:RemoveCard(c)
	mg:AddCard(c)
	mg:Merge(rg)
	return res
end
function c18386170.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local mg=g:Filter(c18386170.ffilter,nil,c)
	local tp=c:GetControler()
	if gc then return mg:IsContains(gc) and c18386170.filterchk(gc,tp,mg,Group.CreateGroup(),c) end
	local sg=Group.CreateGroup()
	return mg:IsExists(c18386170.filterchk,1,nil,tp,mg,sg,c)
end
function c18386170.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local mg=eg:Filter(c18386170.ffilter,nil,e:GetHandler())
	local p=tp
	local sfhchk=false
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	local sg=Group.CreateGroup()
	if gc then
		sg:AddCard(gc) mg:RemoveCard(gc)
		if gc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={gc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				mg=mg:Filter(aux.TuneMagFilterFus,gc,eff[i],f)
			end
		end
		if not gc:IsHasEffect(511002961) then
			mg=mg:Filter(function(c) return not c:IsFusionCode(gc:GetFusionCode()) or c:IsHasEffect(511002961) end,nil)
		end
	end
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local tc=Group.SelectUnselect(mg:Filter(c18386170.filterchk,sg,tp,mg,sg,e:GetHandler()),sg,p)
		if not tc then break end
		if not sg:IsContains(tc) then
			sg:AddCard(tc)
		else
			sg:RemoveCard(tc)
		end
		if tc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				mg=mg:Filter(aux.TuneMagFilterFus,tc,eff[i],f)
			end
		end
		if not tc:IsHasEffect(511002961) then
			mg=mg:Filter(function(c) return not c:IsFusionCode(tc:GetFusionCode()) or c:IsHasEffect(511002961) end,nil)
		end
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	if gc then sg:RemoveCard(gc) end
	Duel.SetFusionMaterial(sg)
end
