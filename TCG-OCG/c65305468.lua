--FNo.0 未来皇ホープ
function c65305468.initial_effect(c)
	--xyz summon
	c65305468.xyz_filter=function(mc,ignoretoken) return mc and mc:IsType(TYPE_XYZ) and not mc:IsSetCard(0x48) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
	c65305468.minxyzct=2
	c65305468.maxxyzct=2
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c65305468.xyzcon)
	e1:SetTarget(c65305468.xyztg)
	e1:SetOperation(c65305468.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--avoid damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--control
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(65305468,0))
	e6:SetCategory(CATEGORY_CONTROL)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetTarget(c65305468.cttg)
	e6:SetOperation(c65305468.ctop)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c65305468.reptg)
	c:RegisterEffect(e7)
end
c65305468.xyz_number=0
function c65305468.xyzfilter1(c,mg,xyz,tp,min,max,matg,ct,matct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	if not c:IsHasEffect(511002116) then
		g=g:Filter(c65305468.xyzfilterchk,nil,c:GetRank())
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
	if xct>max or xmatct>2 then return false end
	if xct>=min and xmatct>=2 then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=aux.MatNumChkF(tg)
		end
		if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
	end
	local retchknum={0}
	local retchk={g:IsExists(c65305468.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct)}
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
					if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
				end
				if xmatct+val<=2 then
					table.insert(retchknum,val)
					table.insert(retchk,g:IsExists(c65305468.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct+val))
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c65305468.xyzfilter2(c,mg,xyz,tp,matg,ct)
	local g
	if not c:IsHasEffect(511002116) and not c:IsHasEffect(511001175) then
		g=mg:Filter(c65305468.xyzfilterchk,nil,c:GetRank())
	else
		g=mg:Clone()
	end
	local tg=matg:Clone()
	g:RemoveCard(c)
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
	if xct==2 then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=aux.MatNumChkF(tg)
		end
		if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
	end
	local eqg=c:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
	g:Merge(eqg)
	local retchknum={0}
	local retchk={g:IsExists(c65305468.xyzfilter2,1,nil,g,xyz,tp,tg,xct)}
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
				if xct+val==2 then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=aux.MatNumChkF(tg)
					end
					if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
				end
				if xct+val<=2 then
					retchknum[#retchknum+1]=val
					retchk[#retchk+1]=g:IsExists(c65305468.xyzfilter2,1,nil,g,xyz,tp,tg,xct+val)
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c65305468.xyzfilterchk(c,rk)
	return c:GetRank()==rk or c:IsHasEffect(511002116) or c:IsHasEffect(511001175)
end
function c65305468.ovfilter2(c,xyz,tp)
	if c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(511002793) then return false end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	return c65305468.ovfilter1(c,xyz,tp)
end
function c65305468.ovfilter1(c,xyzc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsSetCard(0x48) and c:IsCanBeXyzMaterial(xyzc) 
		and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
function c65305468.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og:Filter(c65305468.ovfilter1,nil,c,tp)
	else
		mg=Duel.GetMatchingGroup(c65305468.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
	end
	mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
	if min and min~=99 then
		return mg:IsExists(c65305468.xyzfilter1,1,nil,mg,c,tp,min,max,Group.CreateGroup(),0,0)
	else
		return mg:IsExists(c65305468.xyzfilter2,1,nil,mg,c,tp,Group.CreateGroup(),0)
	end
	return false
end
function c65305468.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
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
				local sg=mg:FilterSelect(tp,c65305468.xyzfilter1,1,1,nil,mg,c,tp,min,max,matg,ct,matct)
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
						if mg:IsExists(c65305468.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and val<2 and (not tgf or tgf(te,xyz)) then
								if (min>=ct and 2>=matct+1+val) 
									or mg:IsExists(c65305468.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1+val) then
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
			mg=og:Filter(c65305468.ovfilter1,nil,c,tp)
			cancel=false
		else
			mg=Duel.GetMatchingGroup(c65305468.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
			if Duel.GetCurrentChain()>0 then cancel=false end
		end
		mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
		if not og or min==99 then
			local ct=0
			local tempg=Group.CreateGroup()
			local matg=Group.CreateGroup()
			local g=Group.CreateGroup()
			while ct<2 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sc=Group.SelectUnselect(mg:Filter(c65305468.xyzfilter2,g,mg,c,tp,matg,ct),g,tp,cancel,cancel)
				if not sc then return false end
				if mg:IsContains(sc) then
					mg:RemoveCard(sc)
					g:AddCard(sc)
					if not sc:IsHasEffect(511002116) and not sc:IsHasEffect(511001175) then
						mg=mg:Filter(c65305468.xyzfilterchk,nil,sc:GetRank())
					end
					mg:Merge(sc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175))
					if sc:IsHasEffect(73941492+TYPE_XYZ) then
						local eff={sc:GetCardEffect(73941492+TYPE_XYZ)}
						for i=1,#eff do
							local f=eff[i]:GetValue()
							mg=mg:Filter(aux.TuneMagFilterXyz,sc,eff[i],f)
						end
					end
					if sc:IsHasEffect(511002116) or sc:IsHasEffect(511001175) then
						tempg:AddCard(sc)
					else
						matg:AddCard(sc)
					end
					ct=ct+1
					if aux.CheckValidMultiXyzMaterial(sc,c) and ct<2 then
						local multi={}
						if mg:IsExists(c65305468.xyzfilter2,1,nil,mg,c,tp,matg,ct) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and val<2 and (not tgf or tgf(te,xyz)) then
								if 2>=ct+val or mg:IsExists(c65305468.xyzfilter2,1,nil,mg,c,tp,matg,ct+val) then
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
		return false
	end
end
function c65305468.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c65305468.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsRelateToBattle() and tc:IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c65305468.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.GetControl(tc,tp,PHASE_BATTLE,1)
	end
end
function c65305468.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(65305468,1)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
