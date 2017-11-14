--エルシャドール・エグリスタ
function c48424886.initial_effect(c)
	c:EnableReviveLimit()
	c48424886.min_material_count=2
	c48424886.max_material_count=2
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c48424886.fuscon)
	e1:SetOperation(c48424886.fusop)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(48424886,0))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1,48424886)
	e3:SetCondition(c48424886.condition)
	e3:SetTarget(c48424886.target)
	e3:SetOperation(c48424886.operation)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(48424886,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(c48424886.thtg)
	e4:SetOperation(c48424886.thop)
	c:RegisterEffect(e4)
end
c48424886.material_setcode=0x9d
function c48424886.ffilter1(c)
	return (c:IsFusionSetCard(0x9d) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c48424886.ffilter2(c,fc,sumtype,tp)
	return (c:IsHasEffect(511002961) or c:IsAttribute(ATTRIBUTE_FIRE,fc,sumtype,tp) or c:IsHasEffect(4904633)) and not c:IsHasEffect(6205579)
end
function c48424886.exfilter(c,g,fc,sumtype,tp)
	return c:IsFaceup() and c:IsCanBeFusionMaterial(fc) and not g:IsContains(c) and (c48424886.ffilter1(c) or c48424886.ffilter2(c,fc,sumtype,tp))
end
function c48424886.ffilter(c,fc,sumtype,tp)
	return c:IsCanBeFusionMaterial(fc) and (c48424886.ffilter1(c) or c48424886.ffilter2(c,fc,sumtype,tp))
end
function c48424886.filterchk(c,tp,mg,sg,exg,mustg,fc,chkf)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then
				mg:Merge(rg)
				return false
			end
			local sg2=mg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_FUSION)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
			for i,f in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then
					mg:Merge(rg)
					return false
				end
			end
			tc=g2:GetNext()
		end	
	end
	sg:AddCard(c)
	if sg:GetCount()<2 then
		if exg:IsContains(c) then
			mg:Sub(exg)
			rg:Merge(exg)
		end
		res=mg:IsExists(c48424886.filterchk,1,sg,tp,mg,sg,exg,mustg,fc,chkf)
	else
		res=sg:Includes(mustg) and aux.FCheckMixGoal(tp,sg,fc,true,true,chkf,c48424886.ffilter1,c48424886.ffilter2)
	end
	sg:RemoveCard(c)
	mg:Merge(rg)
	return res
end
function c48424886.fuscon(e,g,gc,chkf)
	local mustg=nil
	if g==nil then
		mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,nil,REASON_FUSION)
	return mustg:GetCount()==0 end
	local chkf=chkf&0xff
	local c=e:GetHandler()
	local mg=g:Filter(c48424886.ffilter,nil,c,SUMMON_TYPE_FUSION,tp)
	local tp=e:GetHandlerPlayer()
	mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_FUSION)
	if gc then mustg:Merge(gc) end
	local exg=Group.CreateGroup()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		exg=Duel.GetMatchingGroup(c48424886.exfilter,tp,0,LOCATION_MZONE,nil,g,c,SUMMON_TYPE_FUSION,tp)
		mg:Merge(exg)
	end
	if mustg:GetCount()>2 or (Auxiliary.FCheckExact and Auxiliary.FCheckExact~=2) or not mg:Includes(mustg) or mustg:IsExists(aux.NOT(Card.IsCanBeFusionMaterial),1,nil,c) then return false end
	mg:Merge(mustg)
	return mg:IsExists(c48424886.filterchk,1,nil,tp,mg,Group.CreateGroup(),exg,mustg,c,chkf)
end
function c48424886.filterchk2(c,tp,mg,sg,exg,mustg,fc,chkf)
	return not exg:IsContains(c) and c48424886.filterchk(c,tp,mg,sg,exg,mustg,fc,chkf)
end
function c48424886.filterchk3(c,tp,mg,sg,exg,mustg,fc,chkf)
	return exg:IsContains(c) and c48424886.filterchk(c,tp,mg,sg,exg,mustg,fc,chkf)
end
function c48424886.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local chkf=chkf&0xff
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tp=e:GetHandlerPlayer()
	local exg=Group.CreateGroup()
	local mg=eg:Filter(c48424886.ffilter,nil,c,SUMMON_TYPE_FUSION,tp)
	local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_FUSION)
	if gc then mustg:Merge(gc) end
	local p=tp
	local sfhchk=false
	local urg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c48424886.exfilter,tp,0,LOCATION_MZONE,nil,eg,c,SUMMON_TYPE_FUSION,tp)
		exg:Merge(sg)
		mg:Merge(sg)
	end
	if mustg:GetCount()>2 or (Auxiliary.FCheckExact and Auxiliary.FCheckExact~=2) or not mg:Includes(mustg) or mustg:IsExists(aux.NOT(Card.IsCanBeFusionMaterial),1,nil,c) then return false end
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp
		Duel.ConfirmCards(p,sg)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	local sg=mustg
	urg:Merge(mustg)
	for tc in aux.Next(mustg) do
		if exg:IsContains(tc) then
			mg:Sub(exg)
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		end
	end
	while sg:GetCount()<2 do
		local tg=mg:Filter(c48424886.filterchk2,sg,tp,mg,sg,exg,mustg,c,chkf)
		local tg2=mg:Filter(c48424886.filterchk3,sg,tp,mg,sg,exg,mustg,c,chkf)
		if tg2:GetCount()>0 then
			tg:AddCard(fc)
		end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local tc=Group.SelectUnselect(tg,sg,p)
		if fc then
			tg:RemoveCard(fc)
		end
		if not tc then break end
		if tc==fc then
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
			repeat
				tc=Group.SelectUnselect(tg2,sg,p)
			until not sg:IsContains(tc)
			mg:Sub(exg)
			urg:AddCard(tc)
			sg:AddCard(tc)
		end
		if not urg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			else
				sg:RemoveCard(tc)
			end
		end
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(sg)
end
function c48424886.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c48424886.filter(c)
	return c:IsSetCard(0x9d)
end
function c48424886.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c48424886.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c48424886.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c48424886.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c48424886.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c48424886.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c48424886.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c48424886.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c48424886.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c48424886.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
