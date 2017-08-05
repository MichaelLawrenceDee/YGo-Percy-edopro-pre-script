--SNo.0 ホープ・ゼアル
function c52653092.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	c52653092.xyz_filter=function(mc,ignoretoken) return mc and mc:IsType(TYPE_XYZ) and mc:IsSetCard(0x48) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
	c52653092.minxyzct=3
	c52653092.maxxyzct=3
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c52653092.xyzcon)
	e0:SetTarget(c52653092.xyztg)
	e0:SetOperation(c52653092.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52653092,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(aux.XyzCondition2(c52653092.ovfilter,c52653092.xyzop2))
	e1:SetTarget(aux.XyzTarget2(c52653092.ovfilter,c52653092.xyzop2))
	e1:SetOperation(aux.XyzOperation2(c52653092.ovfilter,c52653092.xyzop2))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c52653092.effcon)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c52653092.effcon2)
	e3:SetOperation(c52653092.spsumsuc)
	c:RegisterEffect(e3)
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c52653092.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--activate limit
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(52653092,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMING_DRAW_PHASE)
	e6:SetCountLimit(1)
	e6:SetCondition(c52653092.actcon)
	e6:SetCost(c52653092.actcost)
	e6:SetOperation(c52653092.actop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e7:SetCode(511002571)
	e7:SetLabelObject(e6)
	e7:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e7)
end
c52653092.xyz_number=0
function c52653092.cfilter(c)
	return c:IsSetCard(0x95) and c:GetType()==TYPE_SPELL and c:IsDiscardable()
end
function c52653092.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c52653092.xyzop2(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52653092.cfilter,tp,LOCATION_HAND,0,1,nil) end
	if chk==1 then
		local min=Auxiliary.ProcCancellable and 0 or 1
		local ct=Duel.DiscardHand(tp,c52653092.cfilter,min,1,REASON_COST+REASON_DISCARD,nil)
		if ct>0 then
			return true,true
		else
			return false
		end
	end
end
function c52653092.xyzfilter1(c,mg,xyz,tp,min,max,matg,ct,matct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	if not c:IsHasEffect(511002116) then
		g=g:Filter(c52653092.xyzfilterchk,nil,c:GetRank())
	end
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
	if xct>max or xmatct>3 then return false end
	if xct>=min and xmatct==3 then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=aux.MatNumChkF(tg)
		end
		if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
	end
	local retchknum={0}
	local retchk={g:IsExists(c52653092.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct)}
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
				if xct>=min and xmatct+val>=3 and xct<=max and xmatct+val<=3 then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=aux.MatNumChkF(tg)
					end
					if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
				end
				if xmatct+val<=3 then
					table.insert(retchknum,val)
					table.insert(retchk,g:IsExists(c52653092.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct+val))
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c52653092.xyzfilter2(c,mg,xyz,tp,matg,ct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	if not c:IsHasEffect(511002116) and not c:IsHasEffect(511001175) then
		g=g:Filter(c52653092.xyzfilterchk,nil,c:GetRank())
	end
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
	if xct>3 then return false end
	if xct>=3 then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=aux.MatNumChkF(tg)
		end
		if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
	end
	local eqg=c:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
	g:Merge(eqg)
	local retchknum={0}
	local retchk={g:IsExists(c52653092.xyzfilter2,1,nil,g,xyz,tp,tg,xct)}
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
				if xct+val>=3 and xct+val<=3 then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=aux.MatNumChkF(tg)
					end
					if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
				end
				if xct+val<=3 then
					retchknum[#retchknum+1]=val
					retchk[#retchk+1]=g:IsExists(c52653092.xyzfilter2,1,nil,g,xyz,tp,tg,xct+val)
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c52653092.xyzfilterchk(c,rk)
	return c:GetRank()==rk or c:IsHasEffect(511002116) or c:IsHasEffect(511001175)
end
function c52653092.ovfilter2(c,xyz,tp)
	if c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(511002793) then return false end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	return c52653092.ovfilter1(c,xyz,tp)
end
function c52653092.ovfilter1(c,xyzc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and c:IsCanBeXyzMaterial(xyzc) 
		and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
function c52653092.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og:Filter(c52653092.ovfilter1,nil,c,tp)
	else
		mg=Duel.GetMatchingGroup(c52653092.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
	end
	mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
	if min and min~=99 then
		return mg:IsExists(c52653092.xyzfilter1,1,nil,mg,c,tp,min,max,Group.CreateGroup(),0,0)
	else
		return mg:IsExists(c52653092.xyzfilter2,1,nil,mg,c,tp,Group.CreateGroup(),0)
	end
	return false
end
function c52653092.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		if (og:GetCount()>=3 and og:GetCount()<=3) or not og:IsExists(Card.IsHasEffect,1,nil,511002116) then
			og:KeepAlive()
			e:SetLabelObject(og)
			return true
		elseif not og:IsExists(Card.IsHasEffect,1,nil,511001225) or not mg:IsExists(aux.CheckValidMultiXyzMaterial,1,nil,c) 
			or not mg:IsExists(aux.CheckMultiXyzMaterial,1,nil,c) then
			local sg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116)
			local ct=3-og:GetCount()
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
			while ct<min or matct<3 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sg=mg:FilterSelect(tp,c52653092.xyzfilter1,1,1,nil,mg,c,tp,min,max,matg,ct,matct)
				local sc=sg:GetFirst()
				mg:RemoveCard(sc)
				if sc:IsHasEffect(511002116) then
					tempg:AddCard(sc)
					matct=matct+1
				elseif sc:IsHasEffect(511001225) then
					matg:AddCard(sc)
					ct=ct+1
					if not aux.CheckValidMultiXyzMaterial(sc,c) or (min>=ct and 3>=matct+1) then
						matct=matct+1
					else
						local multi={}
						if mg:IsExists(c52653092.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and val<3 and (not tgf or tgf(te,xyz)) then
								if (min>=ct and 3>=matct+1+val) 
									or mg:IsExists(c52653092.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1+val) then
									table.insert(multi,1+val)
								end
							end
						end
						if #multi==1 then
							matct=matct+multi[1]
						else
							Duel.Hint(HINT_SELECTMSG,tp,513)
							local num=Duel.AnnounceNumber(tp,table.unpack(multi))
							matct=matct+num
						end
					end
				else
					matg:AddCard(sc)
					ct=ct+1
					matct=matct+1
				end
			end
			matg:Merge(tempg)
			matg:KeepAlive()
			e:SetLabelObject(matg)
			return true
		end
		return false
	else
		local mg
		local cancel=true
		if og then
			mg=og:Filter(c52653092.ovfilter1,nil,c,tp)
			cancel=false
		else
			mg=Duel.GetMatchingGroup(c52653092.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
			if Duel.GetCurrentChain()>0 then cancel=false end
		end
		mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
		if not og or min==99 then
			local ct=0
			local tempg=Group.CreateGroup()
			local matg=Group.CreateGroup()
			local g=Group.CreateGroup()
			while ct<3 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sc=Group.SelectUnselect(mg:Filter(c52653092.xyzfilter2,g,mg,c,tp,matg,ct),g,tp,cancel,cancel)
				if not sc then return false end
				if mg:IsContains(sc) then
					mg:RemoveCard(sc)
					g:AddCard(sc)
					if not sc:IsHasEffect(511002116) and not sc:IsHasEffect(511001175) then
						mg=mg:Filter(c52653092.xyzfilterchk,nil,sc:GetRank())
					end
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
					if aux.CheckValidMultiXyzMaterial(sc,c) and ct<3 then
						local multi={}
						if mg:IsExists(c52653092.xyzfilter2,1,nil,mg,c,tp,matg,ct) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and val<3 and (not tgf or tgf(te,xyz)) then
								if 3>=ct+val or mg:IsExists(c52653092.xyzfilter2,1,nil,mg,c,tp,matg,ct+val) then
									table.insert(multi,1+val)
								end
							end
						end
						if #multi==1 then
							if multi[1]>1 then
								ct=ct+multi[1]-1
							end
						else
							Duel.Hint(HINT_SELECTMSG,tp,513)
							local num=Duel.AnnounceNumber(tp,table.unpack(multi))
							if num>1 then
								ct=ct+num-1
							end
						end
					end
				end
			end
			matg:Merge(tempg)
			matg:KeepAlive()
			e:SetLabelObject(matg)
			return true
		end
	end
	return false
end
function c52653092.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c52653092.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c52653092.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c52653092.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c52653092.chlimit)
end
function c52653092.chlimit(e,ep,tp)
	return tp==ep
end
function c52653092.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c52653092.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c52653092.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c52653092.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c52653092.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c52653092.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
