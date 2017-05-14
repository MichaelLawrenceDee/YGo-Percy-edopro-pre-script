--FNo.0 未来皇ホープ－フューチャー・スラッシュ
--Number F0: Utopic Future - Future Slash
--Script by nekrozar
function c43490025.initial_effect(c)
	--xyz summon
	c43490025.xyz_filter=function(mc,ignoretoken) return mc and mc:IsType(TYPE_XYZ) and not mc:IsSetCard(0x48) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
	c43490025.minxyzct=2
	c43490025.maxxyzct=2
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(1073)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c43490025.xyzcon)
	e1:SetTarget(c43490025.xyztg)
	e1:SetOperation(c43490025.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetDescription(aux.Stringid(43490025,1))
	e0:SetCondition(aux.XyzCondition2(c43490025.ovfilter))
	e0:SetTarget(aux.XyzTarget2(c43490025.ovfilter))
	e0:SetOperation(aux.XyzOperation2(c43490025.ovfilter))
	c:RegisterEffect(e0)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c43490025.atkval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--multi attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43490025,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c43490025.atkcon)
	e4:SetCost(c43490025.atkcost)
	e4:SetTarget(c43490025.atktg)
	e4:SetOperation(c43490025.atkop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(511002571)
	e5:SetLabelObject(e4)
	e5:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e5)
end
c43490025.xyz_number=0
function c43490025.xyzfilter1(c,mg,xyz,tp,min,max,matg,ct,matct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	g=g:Filter(c43490025.xyzfilterchk,nil,c:GetRank())
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
	local retchk={g:IsExists(c43490025.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct)}
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
					table.insert(retchk,g:IsExists(c43490025.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct+val))
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c43490025.xyzfilter2(c,mg,xyz,tp,matg,ct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	g=g:Filter(c43490025.xyzfilterchk,nil,c:GetRank())
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
	local retchk={g:IsExists(c43490025.xyzfilter2,1,nil,g,xyz,tp,tg,xct)}
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
					retchk[#retchk+1]=g:IsExists(c43490025.xyzfilter2,1,nil,g,xyz,tp,tg,xct+val)
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c43490025.xyzfilterchk(c,rk)
	return c:GetRank()==rk or c:IsHasEffect(511002116) or c:IsHasEffect(511001175)
end
function c43490025.ovfilter2(c,xyz,tp)
	if c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(511002793) then return false end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	return c43490025.ovfilter1(c,xyz,tp)
end
function c43490025.ovfilter1(c,xyzc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsSetCard(0x48) and c:IsCanBeXyzMaterial(xyzc) 
		and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
function c43490025.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og:Filter(c43490025.ovfilter1,nil,c,tp)
	else
		mg=Duel.GetMatchingGroup(c43490025.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
	end
	mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
	if min and min~=99 then
		return mg:IsExists(c43490025.xyzfilter1,1,nil,mg,c,tp,min,max,Group.CreateGroup(),0,0)
	else
		return mg:IsExists(c43490025.xyzfilter2,1,nil,mg,c,tp,Group.CreateGroup(),0)
	end
	return false
end
function c43490025.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
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
				local sg=mg:FilterSelect(tp,c43490025.xyzfilter1,1,1,nil,mg,c,tp,min,max,matg,ct,matct)
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
						if mg:IsExists(c43490025.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and val<2 and (not tgf or tgf(te,xyz)) then
								if (min>=ct and 2>=matct+1+val) 
									or mg:IsExists(c43490025.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1+val) then
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
			mg=og:Filter(c43490025.ovfilter1,nil,c,tp)
		else
			mg=Duel.GetMatchingGroup(c43490025.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
		end
		mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
		if not og or min==99 then
			local ct=0
			local tempg=Group.CreateGroup()
			local matg=Group.CreateGroup()
			while (matg:IsExists(Card.IsHasEffect,1,nil,91110378) and not aux.MatNumChkF(matg)) 
				or ct<2 or (mg:IsExists(c43490025.xyzfilter2,1,nil,mg,c,tp,matg,ct) and Duel.SelectYesNo(tp,513)) do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sg=mg:FilterSelect(tp,c43490025.xyzfilter2,1,1,nil,mg,c,tp,matg,ct)
				local sc=sg:GetFirst()
				mg:RemoveCard(sc)
				mg=mg:Filter(c43490025.xyzfilterchk,nil,sc:GetRank())
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
					if mg:IsExists(c43490025.xyzfilter2,1,nil,mg,c,tp,matg,ct) then
						table.insert(multi,1)
					end
					local eff={sc:GetCardEffect(511001225)}
					for i=1,#eff do
						local te=eff[i]
						local tgf=te:GetOperation()
						local val=te:GetValue()
						if val>0 and val<2 and (not tgf or tgf(te,xyz)) then
							if 2>=ct+val or mg:IsExists(c43490025.xyzfilter2,1,nil,mg,c,tp,matg,ct+val) then
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
function c43490025.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c43490025.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x107f) or c:IsCode(65305468))
end
function c43490025.atkfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c43490025.atkval(e,c)
	return Duel.GetMatchingGroupCount(c43490025.atkfilter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*500
end
function c43490025.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c43490025.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c43490025.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c43490025.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end