--No.93 希望皇ホープ・カイザー
function c23187256.initial_effect(c)
	--xyz summon
	c23187256.xyz_filter=function(mc,ignoretoken) return mc and mc:IsType(TYPE_XYZ) and mc:IsSetCard(0x48) and mc:GetOverlayCount()>0 and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
	c23187256.minxyzct=2
	c23187256.maxxyzct=99
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c23187256.xyzcon)
	e1:SetTarget(c23187256.xyztg)
	e1:SetOperation(c23187256.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23187256,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c23187256.target)
	e2:SetOperation(c23187256.operation)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c23187256.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
c23187256.xyz_number=93
function c23187256.xyzfilter1(c,mg,xyz,tp,min,max,matg,ct,matct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	if not c:IsHasEffect(511002116) then
		g=g:Filter(c23187256.xyzfilterchk,nil,c:GetRank())
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
	if xct>max or xmatct>99 then return false end
	if xct>=min and xmatct>=2 then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=aux.MatNumChkF(tg)
		end
		if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
	end
	local retchknum={0}
	local retchk={g:IsExists(c23187256.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct)}
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
				if xct>=min and xmatct+val>=2 and xct<=max and xmatct+val<=99 then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=aux.MatNumChkF(tg)
					end
					if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
				end
				if xmatct+val<=99 then
					table.insert(retchknum,val)
					table.insert(retchk,g:IsExists(c23187256.xyzfilter1,1,nil,g,xyz,tp,min,max,tg,xct,xmatct+val))
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c23187256.xyzfilter2(c,mg,xyz,tp,matg,ct)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	if not c:IsHasEffect(511002116) and not c:IsHasEffect(511001175) then
		g=g:Filter(c23187256.xyzfilterchk,nil,c:GetRank())
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
	if xct>99 then return false end
	if xct>=2 then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=aux.MatNumChkF(tg)
		end
		if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
	end
	local eqg=c:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
	g:Merge(eqg)
	local retchknum={0}
	local retchk={g:IsExists(c23187256.xyzfilter2,1,nil,g,xyz,tp,tg,xct)}
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
				if xct+val>=2 and xct+val<=99 then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=aux.MatNumChkF(tg)
					end
					if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
				end
				if xct+val<=99 then
					retchknum[#retchknum+1]=val
					retchk[#retchk+1]=g:IsExists(c23187256.xyzfilter2,1,nil,g,xyz,tp,tg,xct+val)
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function c23187256.xyzfilterchk(c,rk)
	return c:GetRank()==rk or c:IsHasEffect(511002116) or c:IsHasEffect(511001175)
end
function c23187256.ovfilter2(c,xyz,tp)
	if c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(511002793) then return false end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	return c23187256.ovfilter1(c,xyz,tp)
end
function c23187256.ovfilter1(c,xyzc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and c:GetOverlayCount()>0 and c:IsCanBeXyzMaterial(xyzc) 
		and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
function c23187256.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og:Filter(c23187256.ovfilter1,nil,c,tp)
	else
		mg=Duel.GetMatchingGroup(c23187256.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
	end
	mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
	if min and min~=99 then
		return mg:IsExists(c23187256.xyzfilter1,1,nil,mg,c,tp,min,max,Group.CreateGroup(),0,0)
	else
		return mg:IsExists(c23187256.xyzfilter2,1,nil,mg,c,tp,Group.CreateGroup(),0)
	end
	return false
end
function c23187256.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		if (og:GetCount()>=2 and og:GetCount()<=99) or not og:IsExists(Card.IsHasEffect,1,nil,511002116) then
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
				local sg=mg:FilterSelect(tp,c23187256.xyzfilter1,1,1,nil,mg,c,tp,min,max,matg,ct,matct)
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
						if mg:IsExists(c23187256.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and (not tgf or tgf(te,xyz)) then
								if (min>=ct and 2>=matct+1+val) 
									or mg:IsExists(c23187256.xyzfilter1,1,nil,mg,c,tp,min,max,matg,ct,matct+1+val) then
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
		if og then
			mg=og:Filter(c23187256.ovfilter1,nil,c,tp)
		else
			mg=Duel.GetMatchingGroup(c23187256.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
		end
		mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
		if not og or min==99 then
			local ct=0
			local tempg=Group.CreateGroup()
			local matg=Group.CreateGroup()
			while (matg:IsExists(Card.IsHasEffect,1,nil,91110378) and not aux.MatNumChkF(matg)) 
				or ct<2 or (mg:IsExists(c23187256.xyzfilter2,1,nil,mg,c,tp,matg,ct) and Duel.SelectYesNo(tp,513)) do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sg=mg:FilterSelect(tp,c23187256.xyzfilter2,1,1,nil,mg,c,tp,matg,ct)
				local sc=sg:GetFirst()
				mg:RemoveCard(sc)
				if not sc:IsHasEffect(511002116) and not sc:IsHasEffect(511001175) then
					mg=mg:Filter(c23187256.xyzfilterchk,nil,sc:GetRank())
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
				if aux.CheckValidMultiXyzMaterial(sc,c) and ct<2 then
					local multi={}
					if mg:IsExists(c23187256.xyzfilter2,1,nil,mg,c,tp,matg,ct) then
						table.insert(multi,1)
					end
					local eff={sc:GetCardEffect(511001225)}
					for i=1,#eff do
						local te=eff[i]
						local tgf=te:GetOperation()
						local val=te:GetValue()
						if val>0 and (not tgf or tgf(te,xyz)) then
							if 2>=ct+val or mg:IsExists(c23187256.xyzfilter2,1,nil,mg,c,tp,matg,ct+val) then
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
			matg:Merge(tempg)
			matg:KeepAlive()
			e:SetLabelObject(matg)
			return true
		end
	end
	return false
end
function c23187256.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c23187256.filter(c,e,tp)
	return c:IsRankBelow(9) and c:IsAttackBelow(3000) and c:IsSetCard(0x48)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23187256.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c23187256.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c23187256.gfilter(c,rank)
	return c:GetRank()==rank
end
function c23187256.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c23187256.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local ct=c:GetOverlayGroup():GetClassCount(Card.GetCode)
	if ct>ft then ct=ft end
	if g1:GetCount()>0 and ct>0 then
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=g1:Select(tp,1,1,nil)
			local tc=g2:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			g1:Remove(c23187256.gfilter,nil,tc:GetRank())
			ct=ct-1
		until g1:GetCount()==0 or ct==0 or not Duel.SelectYesNo(tp,aux.Stringid(23187256,1))
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(c23187256.val)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTargetRange(1,0)
	Duel.RegisterEffect(e4,tp)
end
function c23187256.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end
function c23187256.indfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c23187256.indcon(e)
	return Duel.IsExistingMatchingCard(c23187256.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
