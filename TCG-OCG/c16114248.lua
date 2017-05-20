--ペア・サイクロイド
function c16114248.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c16114248.fscon)
	e1:SetOperation(c16114248.fsop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
end
function c16114248.mfilter(c,fc)
	return (c:IsRace(RACE_MACHINE) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c16114248.filter(c,tp,mg,sg,code,fc)
	local res=false
	sg:AddCard(c)
	local rg=Group.CreateGroup()
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
	if sg:GetCount()<2 then
		local tcode
		if not c:IsHasEffect(511002961) then
			tcode=c:GetFusionCode()
		end
		res=mg:IsExists(c16114248.filter,1,c,tp,mg,sg,tcode,fc)
	else
		res=(c:IsHasEffect(511002961) or not code or c:IsFusionCode(code)) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0 
			and (not aux.FCheckAdditional or aux.FCheckAdditional(tp,sg,fc))
	end
	sg:RemoveCard(c)
	mg:Merge(rg)
	return res
end
function c16114248.fscon(e,g,gc)
	if g==nil then return true end
	local c=e:GetHandler()
	local tp=c:GetControler()
	local mg=g:Filter(c16114248.mfilter,nil,e:GetHandler())
	if gc then return mg:IsContains(gc) and c16114248.filter(gc,tp,mg,Group.CreateGroup(),nil,c) end
	local sg=Group.CreateGroup()
	return mg:IsExists(c16114248.filter,1,nil,tp,mg,sg,nil,c)
end
function c16114248.fsop(e,tp,eg,ep,ev,re,r,rp,gc)
	local mg=eg:Filter(c16114248.mfilter,gc,e:GetHandler())
	local p=tp
	local sfhchk=false
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,mg)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end			
	local sg
	if gc then
		sg=Group.FromCards(gc)
		if gc then
			sg:AddCard(gc) mg:RemoveCard(gc)
			if gc:IsHasEffect(73941492+TYPE_FUSION) then
				local eff={gc:GetCardEffect(73941492+TYPE_FUSION)}
				for i=1,#eff do
					local f=eff[i]:GetValue()
					mg=mg:Filter(Auxiliary.TuneMagFilterFus,gc,eff[i],f)
				end
			end
		end
	else
		sg=Group.CreateGroup()
	end
	local mc=gc
	if not gc then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		g1=mg:FilterSelect(p,c16114248.filter,1,1,nil,tp,mg,sg,nil,e:GetHandler())
		mc=g1:GetFirst()
		if mc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={mc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				mg=mg:Filter(aux.TuneMagFilterFus,mc,eff[i],f)
			end
		end
	end
	local code
	if not mc:IsHasEffect(511002961) then
		code=mc:GetFusionCode()
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(p,c16114248.filter,1,1,mc,tp,mg,sg,code,e:GetHandler())
	sg:Merge(g2)
	if sfhchk then Duel.ShuffleHand(tp) end
	if gc then sg:RemoveCard(gc) end
	Duel.SetFusionMaterial(sg)
end
