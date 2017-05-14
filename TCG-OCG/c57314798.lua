--No.100 ヌメロン・ドラゴン
function c57314798.initial_effect(c)
	c:EnableReviveLimit()
	c57314798.xyz_filter=function(mc,ignoretoken) return mc and mc:IsType(TYPE_XYZ) and mc:IsSetCard(0x48) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
	c57314798.minxyzct=2
	c57314798.maxxyzct=2
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c57314798.xyzcon)
	e1:SetTarget(c57314798.xyztg)
	e1:SetOperation(c57314798.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57314798,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c57314798.atkcost)
	e2:SetTarget(c57314798.atktg)
	e2:SetOperation(c57314798.atkop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(57314798,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c57314798.descon)
	e3:SetTarget(c57314798.destg)
	e3:SetOperation(c57314798.desop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(57314798,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c57314798.spcon)
	e4:SetTarget(c57314798.sptg)
	e4:SetOperation(c57314798.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(511002571)
	e5:SetLabelObject(e2)
	e5:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e5)
end
c57314798.xyz_number=100
function c57314798.xyzfilter1(c,mg,xyz,tp,min,max,matg,ct,matct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	g=g:Filter(c57314798.xyzfilterchk,nil,c:GetRank(),c:GetCode())
	local xct=ct
	if not c:IsHasEffect(511002116) then
		tg:AddCard(c)
		xct=xct+1
	end
	local xmatct=matct+1
	if c:IsHasEffect(73941492+TYPE_XYZ) then
		local eff={c:GetCardEffect(73941492+TYPE_XYZ)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if tg:IsExists(aux.TuneMagFilter,1,c,eff[i],f) then return false end
			g=g:Filter(aux.TuneMagFilterXyz,nil,eff[i],f)
		end
	end
	if xct>max or xmatct>2 then return false end
	if xct>=min and xmatct>=2 then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=aux.MatNumChkF(tg)
		end
		if ok and tg:IsExists(aux.FieldChk,1,nil,tp,xyz) then return true end
	end
	local retchknum={0}
	local retchk={g:IsExists(c57314798.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct)}
	if c:IsHasEffect(511001225) then
		local eff={c:GetCardEffect(511001225)}
		for i=1,#eff do
			local te=eff[i]
			local tgf=te:GetOperation()
			local val=te:GetValue()
			local redun=false
			for j=1,#retchknum do
				if retchknum[j]==val then redun=true break end
			end	
			if not redun and val>0 and (not tgf or tgf(te,xyz)) then
				if xct>=min and xmatct+val>=2 and xct<=max and xmatct+val<=2 then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=aux.MatNumChkF(tg)
					end
					if ok and tg:IsExists(aux.FieldChk,1,nil,tp,xyz) then return true end
				end
				if xmatct+val<=2 then
					table.insert(retchknum,val)
					table.insert(retchk,g:IsExists(c57314798.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct+val))
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c57314798.xyzfilter2(c,mg,xyz,tp,matg,ct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	g=g:Filter(c57314798.xyzfilterchk,nil,c:GetRank(),c:GetCode())
	if not c:IsHasEffect(511001175) and not c:IsHasEffect(511002116) then
		tg:AddCard(c)
	end
	local xct=ct+1
	if c:IsHasEffect(73941492+TYPE_XYZ) then
		local eff={c:GetCardEffect(73941492+TYPE_XYZ)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if tg:IsExists(aux.TuneMagFilter,1,c,eff[i],f) then return false end
			g=g:Filter(aux.TuneMagFilterXyz,nil,eff[i],f)
		end
	end
	if xct>2 then return false end
	if xct>=2 then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=aux.MatNumChkF(tg)
		end
		if ok and tg:IsExists(aux.FieldChk,1,nil,tp,xyz) then return true end
	end
	local eqg=c:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
	g:Merge(eqg)
	local retchknum={0}
	local retchk={g:IsExists(c57314798.xyzfilter2,1,nil,g,xyz,tp,tg,xct)}
	if c:IsHasEffect(511001225) then
		local eff={c:GetCardEffect(511001225)}
		for i=1,#eff do
			local te=eff[i]
			local tgf=te:GetOperation()
			local val=te:GetValue()
			local redun=false
			for j=1,#retchknum do
				if retchknum[j]==val then redun=true break end
			end
			if val>0 and (not tgf or tgf(te,xyz)) and not redun then
				if xct+val>=2 and xct+val<=2 then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=aux.MatNumChkF(tg)
					end
					if ok and tg:IsExists(aux.FieldChk,1,nil,tp,xyz) then return true end
				end
				if xct+val<=2 then
					retchknum[#retchknum+1]=val
					retchk[#retchk+1]=g:IsExists(c57314798.xyzfilter2,1,nil,g,xyz,tp,tg,xct+val)
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c57314798.xyzfilterchk(c,rk,code)
	return (c:GetRank()==rk and c:IsCode(code)) or c:IsHasEffect(511002116) or c:IsHasEffect(511001175)
end
function c57314798.ovfilter2(c,xyz,tp)
	if c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(511002793) then return false end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	return c57314798.ovfilter1(c,xyz,tp)
end
function c57314798.ovfilter1(c,xyzc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsSetCard(0x48) and c:IsCanBeXyzMaterial(xyzc) 
		and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
function c57314798.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og:Filter(c57314798.ovfilter1,nil,c,tp)
	else
		mg=Duel.GetMatchingGroup(c57314798.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
	end
	mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
	if min and min~=99 then
		return mg:IsExists(c57314798.xyzfilter1,1,nil,mg,c,tp,min,max,Group.CreateGroup(),0,0)
	else
		return mg:IsExists(c57314798.xyzfilter2,1,nil,mg,c,tp,Group.CreateGroup(),0)
	end
	return false
end
function c57314798.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		if (og:GetCount()>=2 and og:GetCount()<=2) or not og:IsExists(Card.IsHasEffect,1,nil,511002116) then
			og:KeepAlive()
			e:SetLabelObject(og)
			return true
		elseif not og:IsExists(Card.IsHasEffect,1,nil,511001225) or not mg:IsExists(aux.CheckValidMultiXyzMaterial,1,nil,c) 
			or not mg:IsExists(aux.CheckMultiXyzMaterial,1,nil,c) then
			local sg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116)
			local ct=2-og:GetCount()
			local sg2=og:Filter(aux.Check2XyzMaterial,nil,c)
			sg:Merge(sg2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=sg:Select(tp,ct,ct,nil)
			local matg=og:Clone()
			matg:Merge(mg)
			matg:KeepAlive()
			e:SetLabelObject(matg)
			return true
		else
			local ct,matct,min,max=0,0,og:GetCount(),og:GetCount()
			local matg=Group.CreateGroup()
			local mg=og:Clone()
			local tempg=Group.CreateGroup()
			mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
			while ct<min or matct<2 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sg=mg:FilterSelect(tp,c57314798.xyzfilter1,1,1,nil,mg,c,tp,min,max,matg,ct,matct)
				local sc=sg:GetFirst()
				mg:RemoveCard(sc)
				if sc:IsHasEffect(511002116) then
					tempg:AddCard(sc)
					matct=matct+1
				elseif sc:IsHasEffect(511001225) then
					matg:AddCard(sc)
					ct=ct+1
					if not aux.CheckValidMultiXyzMaterial(sc,c) or (min>=ct and 2>=matct+1) then
						matct=matct+1
					else
						local multi={}
						if mg:IsExists(c57314798.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and val<2 and (not tgf or tgf(te,xyz)) then
								if (min>=ct and 2>=matct+1+val) 
									or mg:IsExists(c57314798.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1+val) then
									table.insert(multi,1+val)
								end
							end
						end
						if #multi==1 then
							matct=multi[1]
						else
							Duel.Hint(HINT_SELECTMSG,tp,513)
							Duel.AnnounceNumber(tp,table.unpack(multi))
						end
					end
				else
					matg:AddCard(sc)
					ct=ct+1
					matct=matct+1
				end
			end
		end
		return false
	else
		local mg
		if og then
			mg=og:Filter(c57314798.ovfilter1,nil,c,tp)
		else
			mg=Duel.GetMatchingGroup(c57314798.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
		end
		mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
		if not og or min==99 then
			local ct=0
			local tempg=Group.CreateGroup()
			local matg=Group.CreateGroup()
			while (matg:IsExists(Card.IsHasEffect,1,nil,91110378) and not aux.MatNumChkF(matg)) 
				or ct<2 or (mg:IsExists(c57314798.xyzfilter2,1,nil,mg,c,tp,matg,ct) and Duel.SelectYesNo(tp,513)) do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sg=mg:FilterSelect(tp,c57314798.xyzfilter2,1,1,nil,mg,c,tp,matg,ct)
				local sc=sg:GetFirst()
				mg:RemoveCard(sc)
				mg=mg:Filter(c57314798.xyzfilterchk,nil,sc:GetRank(),sc:GetCode())
				mg:Merge(sc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175))
				if sc:IsHasEffect(73941492+TYPE_XYZ) then
					local eff={sc:GetCardEffect(73941492+TYPE_XYZ)}
					for i=1,#eff do
						local f=eff[i]:GetValue()
						mg=mg:Filter(aux.TuneMagFilterXyz,sc,eff[i],f)
					end
				end
				if sc:IsHasEffect(511002116) then
					tempg:AddCard(sc)
				else
					matg:AddCard(sc)
				end
				ct=ct+1
				if aux.CheckValidMultiXyzMaterial(sc,c) and ct<2 then
					local multi={}
					if mg:IsExists(c57314798.xyzfilter2,1,nil,mg,c,tp,matg,ct) then
						table.insert(multi,1)
					end
					local eff={sc:GetCardEffect(511001225)}
					for i=1,#eff do
						local te=eff[i]
						local tgf=te:GetOperation()
						local val=te:GetValue()
						if val>0 and val<2 and (not tgf or tgf(te,xyz)) then
							if 2>=ct+val or mg:IsExists(c57314798.xyzfilter2,1,nil,mg,c,tp,matg,ct+val) then
								table.insert(multi,1+val)
							end
						end
					end
					if #multi==1 then
						matct=multi[1]
					else
						Duel.Hint(HINT_SELECTMSG,tp,513)
						Duel.AnnounceNumber(tp,table.unpack(multi))
					end
				end
			end
			matg:KeepAlive()
			e:SetLabelObject(matg)
			return true
		end
	end
	return false
end
function c57314798.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=e:GetLabelObject()
	if not g then return end
	local remg=g:Filter(Card.IsHasEffect,nil,511002116)
	local tc=remg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(511002115,RESET_EVENT+0x1fe0000,0,0)
		tc=remg:GetNext()
	end
	g:Remove(Card.IsHasEffect,nil,511002116)
	g:Remove(Card.IsHasEffect,nil,511002115)
	local sg=Group.CreateGroup()
	tc=g:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g:Filter(function(c) return c:GetEquipTarget() end,nil))
	Duel.Overlay(c,g)
	g:DeleteGroup()
end
function c57314798.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c57314798.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetRank()>0
end
function c57314798.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57314798.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c57314798.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c57314798.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local atk=g:GetSum(Card.GetRank)
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk*1000)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			c:RegisterEffect(e1)
		end
	end
end
function c57314798.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c57314798.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c57314798.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function c57314798.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g1=Duel.SelectMatchingCard(tp,c57314798.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local g2=Duel.SelectMatchingCard(1-tp,c57314798.setfilter,1-tp,LOCATION_GRAVE,0,1,1,nil)
		local tc1=g1:GetFirst()
		local tc2=g2:GetFirst()
		if (tc1 and tc1:IsHasEffect(EFFECT_NECRO_VALLEY)) or (tc2 and tc2:IsHasEffect(EFFECT_NECRO_VALLEY)) then return end
		if tc1 then
			Duel.SSet(tp,tc1)
			Duel.ConfirmCards(1-tp,tc1)
		end
		if tc2 then
			Duel.SSet(1-tp,tc2)
			Duel.ConfirmCards(tp,tc2)
		end
	end
end
function c57314798.spfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c57314798.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and not Duel.IsExistingMatchingCard(c57314798.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c57314798.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c57314798.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
