
function Auxiliary.XyzAlterFilter(c,alterf,xyzc,e,tp,op)
	if not alterf(c) or not c:IsCanBeXyzMaterial(xyzc) or (c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_XYZ_MATERIAL)) 
		or (op and op(e,tp,0,c)) then return false end
	if xyzc:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:GetSequence()<5
	end
end
--Xyz monster, lv k*n
function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op,mustbemat)
	--mustbemat for Startime Magician
	if not maxct then maxct=ct end	
	if c.xyz_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.xyz_filter=function(mc,ignoretoken) return mc and (not f or f(mc)) and mc:IsXyzLevel(c,lv) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
		mt.xyz_parameters={mt.xyz_filter,lv,ct,alterf,desc,maxct,op,mustbemat}
		mt.minxyzct=ct
		mt.maxxyzct=maxct
	end
	
	local chk1=Effect.CreateEffect(c)
	chk1:SetType(EFFECT_TYPE_SINGLE)
	chk1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	chk1:SetCode(946)
	chk1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct,mustbemat))
	chk1:SetTarget(Auxiliary.XyzTarget(f,lv,ct,maxct,mustbemat))
	chk1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct,mustbemat))
	c:RegisterEffect(chk1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1073)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct,mustbemat))
	e1:SetTarget(Auxiliary.XyzTarget(f,lv,ct,maxct,mustbemat))
	e1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct,mustbemat))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	if alterf then
		local chk2=chk1:Clone()
		chk2:SetDescription(desc)
		chk2:SetCondition(Auxiliary.XyzCondition2(alterf,op))
		chk2:SetTarget(Auxiliary.XyzTarget2(alterf,op))
		chk2:SetOperation(Auxiliary.XyzOperation2(alterf,op))
		c:RegisterEffect(chk2)
		local e2=e1:Clone()
		e2:SetDescription(desc)
		e2:SetCondition(Auxiliary.XyzCondition2(alterf,op))
		e2:SetTarget(Auxiliary.XyzTarget2(alterf,op))
		e2:SetOperation(Auxiliary.XyzOperation2(alterf,op))
		c:RegisterEffect(e2)
	end
	
	if not xyztemp then
		xyztemp=true
		xyztempg0=Group.CreateGroup()
		xyztempg0:KeepAlive()
		xyztempg1=Group.CreateGroup()
		xyztempg1:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e3:SetCode(EVENT_ADJUST)
		e3:SetCountLimit(1)
		e3:SetOperation(Auxiliary.XyzMatGenerate)
		Duel.RegisterEffect(e3,0)
	end
end
function Auxiliary.XyzMatGenerate(e,tp,eg,ep,ev,re,r,rp)
	local tck0=Duel.CreateToken(0,946)
	xyztempg0:AddCard(tck0)
	local tck1=Duel.CreateToken(1,946)
	xyztempg1:AddCard(tck1)
end
--Xyz Summon(normal)
function Auxiliary.XyzMatFilter2(c,f,lv,xyz,tp)
	if c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(511002793) then return false end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	return Auxiliary.XyzMatFilter(c,f,lv,xyz,tp)
end
function Auxiliary.XyzMatFilter(c,f,lv,xyz,tp)
	return (not f or f(c)) and c:IsXyzLevel(xyz,lv) and c:IsCanBeXyzMaterial(xyz) 
		and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
function Auxiliary.XyzSubMatFilter(c,fil,lv,xg)
	--Solid Overlay-type
	local te=c:GetCardEffect(511000189)
	if not te then return false end
	local f=te:GetValue()
	if type(f)=='function' then
		if f(te)~=lv then return false end
	else
		if f~=lv then return false end
	end
	return xg:IsExists(Auxiliary.XyzSubFilterChk,1,nil,fil)
end
function Auxiliary.XyzSubFilterChk(c,f)
	return (not f or f(c))
end
function Auxiliary.XyzFreeMatFilter(c)
	return not c:IsHasEffect(73941492+TYPE_XYZ) and not c:IsHasEffect(91110378)
end
function Auxiliary.NeedRecursionXyz(c,...)
	local tab={...}
	for i=1,#tab do
		if c:IsHasEffect(tab[i]) then return true end
	end
	return false
end
function Auxiliary.XyzRecursionChk1(c,mg,xyz,tp,min,max,minc,maxc,matg,ct,matct,mustbemat)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
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
			if tg:IsExists(Auxiliary.TuneMagFilter,1,c,eff[i],f) then return false end
			g=g:Filter(Auxiliary.TuneMagFilterXyz,nil,eff[i],f)
		end
	end
	if xct>max or xmatct>maxc then return false end
	if xct>=min and xmatct>=minc then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=Auxiliary.MatNumChkF(tg)
		end
		if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
	end
	local retchknum={0}
	local retchk={g:IsExists(Auxiliary.XyzRecursionChk1,1,nil,g,xyz,tp,min,max,minc,maxc,tg,xct,xmatct,mustbemat)}
	if c:IsHasEffect(511001225) and not mustbemat then
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
				if xct>=min and xmatct+val>=minc and xct<=max and xmatct+val<=maxc then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=Auxiliary.MatNumChkF(tg)
					end
					if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
				end
				if xmatct+val<=maxc then
					table.insert(retchknum,val)
					table.insert(retchk,g:IsExists(Auxiliary.XyzRecursionChk1,1,nil,g,xyz,tp,min,max,minc,maxc,tg,xct,xmatct+val,mustbemat))
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function Auxiliary.XyzRecursionChk2(c,mg,xyz,tp,minc,maxc,matg,ct,mustbemat)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	if c:IsHasEffect(511001175) and not tg:IsContains(c:GetEquipTarget()) then return false end
	if not c:IsHasEffect(511001175) and not c:IsHasEffect(511002116) then
		tg:AddCard(c)
	end
	local xct=ct+1
	if c:IsHasEffect(73941492+TYPE_XYZ) then
		local eff={c:GetCardEffect(73941492+TYPE_XYZ)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if tg:IsExists(Auxiliary.TuneMagFilter,1,c,eff[i],f) then return false end
			g=g:Filter(Auxiliary.TuneMagFilterXyz,nil,eff[i],f)
		end
	end
	if xct>maxc then return false end
	if xct>=minc then
		local ok=true
		if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
			ok=Auxiliary.MatNumChkF(tg)
		end
		if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
	end
	if not mustbemat and (c:IsHasEffect(91110378) or c:IsHasEffect(73941492+TYPE_XYZ)) then
		local eqg=c:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
		g:Merge(eqg)
	end
	local retchknum={0}
	local retchk={g:IsExists(Auxiliary.XyzRecursionChk2,1,nil,g,xyz,tp,minc,maxc,tg,xct,mustbemat)}
	if c:IsHasEffect(511001225) and not mustbemat then
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
				if xct+val>=minc and xct+val<=maxc then
					local ok=true
					if tg:IsExists(Card.IsHasEffect,1,nil,91110378) then
						ok=Auxiliary.MatNumChkF(tg)
					end
					if ok and (Duel.GetLocationCountFromEx(tp)>0 or tg:IsExists(Auxiliary.FieldChk,1,nil,tp,xyz)) then return true end
				end
				if xct+val<=maxc then
					retchknum[#retchknum+1]=val
					retchk[#retchk+1]=g:IsExists(Auxiliary.XyzRecursionChk2,1,nil,g,xyz,tp,minc,maxc,tg,xct+val,mustbemat)
				end
			end
		end
	end
	for i=1,#retchk do
		if retchk[i] then return true end
	end
	return false
end
function Auxiliary.MatNumChkF(tg)
	local chkg=tg:Filter(Card.IsHasEffect,nil,91110378)
	for chkc in aux.Next(chkg) do
		local eff={chkc:GetCardEffect(91110378)}
		for j=1,#eff do
			local rct=eff[j]:GetValue()
			local comp=eff[j]:GetLabel()
			if not Auxiliary.MatNumChk(tg:FilterCount(Card.IsType,nil,TYPE_MONSTER),rct,comp) then return false end
		end
	end
	return true
end
function Auxiliary.MatNumChk(matct,ct,comp)
	local ok=false
	if not ok and bit.band(comp,0x1)==0x1 and matct>ct then ok=true end
	if not ok and bit.band(comp,0x2)==0x2 and matct==ct then ok=true end
	if not ok and bit.band(comp,0x4)==0x4 and matct<ct then ok=true end
	return ok
end
function Auxiliary.TuneMagFilter(c,e,f)
	return f and not f(e,c)
end
function Auxiliary.TuneMagFilterXyz(c,e,f)
	return not f or f(e,c) or c:IsHasEffect(511002116) or c:IsHasEffect(511001175)
end
function Auxiliary.XyzCondition(f,lv,minc,maxc,mustbemat)
	--og: use special material
	return	function(e,c,og,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				local xg=nil
				if tp==0 then
					xg=xyztempg0
				else
					xg=xyztempg1
				end
				if not xg or xg:GetCount()==0 then return false end
				local mg
				if og then
					mg=og:Filter(Auxiliary.XyzMatFilter,nil,f,lv,c,tp)
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzMatFilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,f,lv,c,tp)
					if not mustbemat then
						local eqg=mg:Filter(Auxiliary.XyzFreeMatFilter,nil)
						local eqmg=Group.CreateGroup()
						for tc in aux.Next(eqg) do
							local eq=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
							eqmg:Merge(eq)
						end
						mg:Merge(eqmg)
						mg:Merge(Duel.GetMatchingGroup(Auxiliary.XyzSubMatFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,f,lv,xg))
					end
				end
				local minusg=Group.CreateGroup()
				if not mustbemat then
					minusg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
				end
				local minc=minc-minusg:GetCount()
				local maxc=maxc-minusg:GetCount()
				local sg=mg:Filter(Auxiliary.XyzFreeMatFilter,nil)
				if (not min or min==99 or (sg:GetCount()>=min and min>=minc)) and sg:GetCount()>=minc 
					and (Duel.GetLocationCountFromEx(tp)>0 or sg:IsExists(Auxiliary.FieldChk,1,nil,tp,c)) then return true end
				if mustbemat then
					if not mg:IsExists(Auxiliary.NeedRecursionXyz,1,nil,73941492+TYPE_XYZ,91110378) then return false end
				else
					if not mg:IsExists(Auxiliary.NeedRecursionXyz,1,nil,73941492+TYPE_XYZ,91110378,511001225) then return false end
				end
				if not mustbemat and mg:IsExists(Auxiliary.CheckMultiXyzMaterial,1,nil,c) then
					minc=minc+minusg:GetCount()
					maxc=maxc+minusg:GetCount()
					mg:Merge(minusg)
				end
				if min and min~=99 then
					return mg:IsExists(Auxiliary.XyzRecursionChk1,1,nil,mg,c,tp,min,max,minc,maxc,Group.CreateGroup(),0,0,mustbemat)
				else
					return mg:IsExists(Auxiliary.XyzRecursionChk2,1,nil,mg,c,tp,minc,maxc,Group.CreateGroup(),0,mustbemat)
				end
				return false
			end
end
function Auxiliary.CheckRecursionCode(c,code,mg,xyz,tp,minc,maxc,matg,ct,mustbemat)
	if not c:IsHasEffect(code) then return false end
	return Auxiliary.XyzRecursionChk2(c,mg,xyz,tp,minc,maxc,matg,ct,mustbemat)
end
function Auxiliary.FieldChk(c,tp,xyzc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c),xyzc)>0 and (c:IsLocation(LOCATION_MZONE) and c:IsControler(tp))
end
function Auxiliary.CheckMultiXyzMaterial(c,xyz)
	if not c:IsHasEffect(511001225) then return false end
	local eff={c:GetCardEffect(511001225)}
	for i=1,#eff do
		local te=eff[i]
		local tgf=te:GetOperation()
		local val=te:GetValue()
		if val>1 and (not tgf or tgf(te,xyz)) then return true end
	end
	return false
end
function Auxiliary.CheckValidMultiXyzMaterial(c,xyz)
	if not c:IsHasEffect(511001225) then return false end
	local eff={c:GetCardEffect(511001225)}
	for i=1,#eff do
		local te=eff[i]
		local tgf=te:GetOperation()
		if not tgf or tgf(te,xyz) then return true end
	end
	return false
end
function Auxiliary.Check2XyzMaterial(c,xyz)
	if not c:IsHasEffect(511001225) then return false end
	local eff={c:GetCardEffect(511001225)}
	for i=1,#eff do
		local te=eff[i]
		local tgf=te:GetOperation()
		local val=te:GetValue()
		if val==1 and (not tgf or tgf(te,xyz)) then return true end
	end
	return false
end
function Auxiliary.XyzTarget(f,lv,minc,maxc,mustbemat)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					if (og:GetCount()>=minc and og:GetCount()<=maxc) or not og:IsExists(Card.IsHasEffect,1,nil,511002116) then
						og:KeepAlive()
						e:SetLabelObject(og)
						return true
					elseif not og:IsExists(Card.IsHasEffect,1,nil,511001225) or not mg:IsExists(Auxiliary.CheckValidMultiXyzMaterial,1,nil,c) 
						or not mg:IsExists(Auxiliary.CheckMultiXyzMaterial,1,nil,c) then
						local sg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116)
						local ct=minc-og:GetCount()
						local sg2=og:Filter(Auxiliary.Check2XyzMaterial,nil,c)
						sg:Merge(sg2)
						local mg=Group.CreateGroup()
						while mg:GetCount()<ct do
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
							local tc=Group.SelectUnselect(sg,mg,tp)
							if sg:IsContains(tc) then
								mg:AddCard(tc)
								sg:RemoveCard(tc)
							else
								mg:RemoveCard(tc)
								sg:AddCard(tc)
							end
						end
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
						local g=Group.CreateGroup()
						mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
						while ct<min or matct<minc do
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
							local sc=Group.SelectUnselect(mg:Filter(Auxiliary.XyzRecursionChk1,g,mg,c,tp,min,max,minc,maxc,matg,ct,matct,mustbemat),g,tp)
							if not g:IsContains(sc) then
								mg:RemoveCard(sc)
								g:AddCard(sc)
								if sc:IsHasEffect(511002116) then
									tempg:AddCard(sc)
									matct=matct+1
								elseif sc:IsHasEffect(511001225) then
									matg:AddCard(sc)
									ct=ct+1
									if not Auxiliary.CheckValidMultiXyzMaterial(sc,c) or (min>=ct and minc>=matct+1) then
										matct=matct+1
									else
										local multi={}
										if mg:IsExists(Auxiliary.XyzRecursionChk1,1,nil,mg,c,tp,min,max,minc,maxc,matg,ct,matct+1,mustbemat) then
											table.insert(multi,1)
										end
										local eff={sc:GetCardEffect(511001225)}
										for i=1,#eff do
											local te=eff[i]
											local tgf=te:GetOperation()
											local val=te:GetValue()
											if val>0 and (not tgf or tgf(te,xyz)) then
												if (min>=ct and minc>=matct+1+val) 
													or mg:IsExists(Auxiliary.XyzRecursionChk1,1,nil,mg,c,tp,min,max,minc,maxc,matg,ct,matct+1+val,mustbemat) then
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
						end
					end
					return false
				else
					local xg=nil
					if tp==0 then
						xg=xyztempg0
					else
						xg=xyztempg1
					end
					local mg
					local cancel=true
					if og then
						mg=og:Filter(Auxiliary.XyzMatFilter,nil,f,lv,c,tp)
						cancel=false
					else
						mg=Duel.GetMatchingGroup(Auxiliary.XyzMatFilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,f,lv,c,tp)
						if not mustbemat then
							local eqg=mg:Filter(Auxiliary.XyzFreeMatFilter,nil)
							local eqmg=Group.CreateGroup()
							for tc in aux.Next(eqg) do
								local eq=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
								eqmg:Merge(eq)
							end
							mg:Merge(eqmg)
							mg:Merge(Duel.GetMatchingGroup(Auxiliary.XyzSubMatFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,f,lv,xg))
						end
						if Duel.GetCurrentChain()>0 then cancel=false end
					end
					cancel=cancel or Auxiliary.ProcCancellable
					if not mustbemat then
						mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
					end
					if not og or min==99 then
						if mustbemat then
							if not mg:IsExists(Auxiliary.NeedRecursionXyz,1,nil,73941492+TYPE_XYZ,91110378) 
								or (not mg:IsExists(Auxiliary.CheckRecursionCode,1,nil,73941492+TYPE_XYZ,mg,c,tp,minc,maxc,Group.CreateGroup(),0,mustbemat) 
								and not mg:IsExists(Auxiliary.CheckRecursionCode,1,nil,91110378,mg,c,tp,minc,maxc,Group.CreateGroup(),0,mustbemat)) then
								--start of part 1 no recursion
								local matg=Group.CreateGroup()
								if Duel.GetLocationCountFromEx(tp)>0 then
									while matg:GetCount()<maxc do
										if mg:GetCount()==0 then break end
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
										cancel=matg:GetCount()>=minc or (not og and Duel.GetCurrentChain()<=0 and matg:GetCount()==0)
										local tc=Group.SelectUnselect(mg,matg,tp,cancel,cancel)
										if not tc then
											if matg:GetCount()<minc then return false end
											break
										else
											if mg:IsContains(tc) then
												mg:RemoveCard(tc) matg:AddCard(tc)
											else
												mg:AddCard(tc) matg:RemoveCard(tc)
											end
										end
									end
								else
									while matg:GetCount()<maxc do
										local tc
										if mg:GetCount()==0 then break end
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
										cancel=matg:GetCount()>=minc or (not og and Duel.GetCurrentChain()<=0 and matg:GetCount()==0)
										if matg:IsExists(Auxiliary.FieldChk,1,nil,tp,c) then
											tc=Group.SelectUnselect(mg,matg,tp,cancel,cancel)
										else
											tc=Group.SelectUnselect(mg:Filter(Auxiliary.FieldChk,matg,tp,c),matg,tp,cancel,cancel)
										end
										if not tc then
											if not matg:IsExists(Auxiliary.FieldChk,1,nil,tp,c) or matg:GetCount()<minc then return false end
											break
										else
											if mg:IsContains(tc) then
												mg:RemoveCard(tc) matg:AddCard(tc)
											else
												mg:AddCard(tc) matg:RemoveCard(tc)
											end
										end
									end
								end
								matg:KeepAlive()
								e:SetLabelObject(matg)
								return true
								--end of part 1 no recursion
							else
								--start of part 2 mustbemat recursion
								local matg=Group.CreateGroup()
								local ct=0
								while ct<maxc do
									if mg:FilterCount(Auxiliary.XyzRecursionChk2,matg,mg,c,tp,minc,maxc,matg,ct,mustbemat)==0 then break end
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
									local sc=Group.SelectUnselect(mg:Filter(Auxiliary.XyzRecursionChk2,matg,mg,c,tp,minc,maxc,matg,ct,mustbemat),matg,tp,cancel,cancel)
									if not sc then
										if ct<minc or (matg:IsExists(Card.IsHasEffect,1,nil,91110378) and not aux.MatNumChkF(matg)) then return false end
										break
									else
										if ct>=minc and (not matg:IsExists(Card.IsHasEffect,1,nil,91110378) or aux.MatNumChkF(matg)) then
											cancel=true
										else
											cancel=not og and Duel.GetCurrentChain()<=0
										end
									end
									if not matg:IsContains(sc) then
										mg:RemoveCard(sc)
										matg:AddCard(sc)
										if sc:IsHasEffect(73941492+TYPE_XYZ) then
											local eff={sc:GetCardEffect(73941492+TYPE_XYZ)}
											for i=1,#eff do
												local f=eff[i]:GetValue()
												mg=mg:Filter(Auxiliary.TuneMagFilterXyz,sc,eff[i],f)
											end
										end
									end
									ct=ct+1
								end
								matg:KeepAlive()
								e:SetLabelObject(matg)
								return true
								--end of part 2 mustbemat recursion
							end
						else
							local multichkg=mg:Filter(Auxiliary.CheckValidMultiXyzMaterial,nil,c)
							local multichkg2=multichkg:Filter(Auxiliary.CheckMultiXyzMaterial,nil,c)
							if not mg:IsExists(Auxiliary.NeedRecursionXyz,1,nil,73941492+TYPE_XYZ,91110378) 
								or (not mg:IsExists(Auxiliary.CheckRecursionCode,1,nil,73941492+TYPE_XYZ,mg,c,tp,minc,maxc,Group.CreateGroup(),0,mustbemat) 
								and not mg:IsExists(Auxiliary.CheckRecursionCode,1,nil,91110378,mg,c,tp,minc,maxc,Group.CreateGroup(),0,mustbemat)
								and not multichkg2:IsExists(Auxiliary.CheckRecursionCode,1,nil,511001225,mg,c,tp,minc,maxc,Group.CreateGroup(),0,mustbemat)) then
								mg=mg:Filter(function(c) return not c:IsHasEffect(73941492+TYPE_XYZ) and not c:IsHasEffect(91110378) end,nil)
								if not mg:IsExists(Card.IsHasEffect,1,nil,511001175) and not multichkg:IsExists(Auxiliary.Check2XyzMaterial,1,nil,c) then
									--start of part 3 no recursion
									--no multi material and no Equip Material
									local matg=Group.CreateGroup()
									if Duel.GetLocationCountFromEx(tp)>0 then
										while matg:GetCount()<maxc do
											if mg:GetCount()==0 then break end
											Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
											cancel=matg:GetCount()>=minc or (not og and Duel.GetCurrentChain()<=0 and matg:GetCount()==0)
											local tc=Group.SelectUnselect(mg,matg,tp,cancel,cancel)
											if not tc then
												if matg:GetCount()<minc then return false end
												break
											else
												if mg:IsContains(tc) then
													mg:RemoveCard(tc) matg:AddCard(tc)
												else
													mg:AddCard(tc) matg:RemoveCard(tc)
												end
											end
										end
									else
										while matg:GetCount()<maxc do
											local tc
											if mg:GetCount()==0 then break end
											Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
											cancel=matg:GetCount()>=minc or (not og and Duel.GetCurrentChain()<=0 and matg:GetCount()==0)
											if matg:IsExists(Auxiliary.FieldChk,1,nil,tp,c) then
												tc=Group.SelectUnselect(mg,matg,tp,cancel,cancel)
											else
												tc=Group.SelectUnselect(mg:Filter(Auxiliary.FieldChk,matg,tp,c),matg,tp,cancel,cancel)
											end
											if not tc then
												if not matg:IsExists(Auxiliary.FieldChk,1,nil,tp,c) or matg:GetCount()<minc then return false end
												break
											else
												if mg:IsContains(tc) then
													mg:RemoveCard(tc) matg:AddCard(tc)
												else
													mg:AddCard(tc) matg:RemoveCard(tc)
												end
											end
										end
									end
									matg:KeepAlive()
									e:SetLabelObject(matg)
									return true
									--end of part 3 no recursion
								else
									--start of part 4 loop for double material/equip material
									local ct=0
									mg:Remove(Card.IsHasEffect,nil,511001175)
									local matg=Group.CreateGroup()
									while ct<maxc do
										if mg:GetCount()==0 then break end
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
										local tc
										if matg:IsExists(Auxiliary.FieldChk,1,nil,tp,c) then
											tc=Group.SelectUnselect(mg,matg:Filter(function(rc) return rc:GetFlagEffect(511001226)==0 end,nil),tp,cancel,cancel)
										else
											tc=Group.SelectUnselect(mg:Filter(Auxiliary.FieldChk,matg,tp,c),matg:Filter(function(rc) return rc:GetFlagEffect(511001226)==0 end,nil),tp,cancel,cancel)
										end
										if not tc then
											if not matg:IsExists(Auxiliary.FieldChk,1,nil,tp,c) or matg:GetCount()<minc then return false end
											break
										end
										if mg:IsContains(tc) then
											mg:Merge(tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175))
											if not Auxiliary.Check2XyzMaterial(tc,c) or tc:GetFlagEffect(511001226)>0 then
												mg:RemoveCard(tc)
											else
												--2 xyz material monsters can be selected twice
												tc:RegisterFlagEffect(511001226,RESET_EVENT+0x1fe0000,0,0)
											end
											matg:AddCard(tc)
											ct=ct+1
											if ct>=minc then
												cancel=true
											end
										end
									end
									matg:KeepAlive()
									e:SetLabelObject(matg)
									return true
									--end of part 4 loop for double material/equip material
								end
							else
								local ct=0
								local tempg=Group.CreateGroup()
								local matg=Group.CreateGroup()
								local g=Group.CreateGroup()
								while ct<maxc do
									if mg:FilterCount(Auxiliary.XyzRecursionChk2,g,mg,c,tp,minc,maxc,matg,ct,mustbemat)==0 then break end
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
									local sc=Group.SelectUnselect(mg:Filter(Auxiliary.XyzRecursionChk2,g,mg,c,tp,minc,maxc,matg,ct,mustbemat),g,tp,cancel,cancel)
									if not sc then
										if not matg:IsExists(Auxiliary.FieldChk,1,nil,tp,c) or matg:GetCount()<minc 
											or (matg:IsExists(Card.IsHasEffect,1,nil,91110378) and not Auxiliary.MatNumChkF(matg)) then return false end
										break
									end
									if not matg:IsContains(sc) then
										mg:RemoveCard(sc)
										g:AddCard(sc)
										mg:Merge(sc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175))
										if sc:IsHasEffect(73941492+TYPE_XYZ) then
											local eff={sc:GetCardEffect(73941492+TYPE_XYZ)}
											for i=1,#eff do
												local f=eff[i]:GetValue()
												mg=mg:Filter(Auxiliary.TuneMagFilterXyz,sc,eff[i],f)
											end
										end
										if sc:IsHasEffect(511002116) then
											tempg:AddCard(sc)
										else
											matg:AddCard(sc)
										end
										ct=ct+1
										if Auxiliary.CheckValidMultiXyzMaterial(sc,c) and ct<minc then
											local multi={}
											if mg:IsExists(Auxiliary.XyzRecursionChk2,1,nil,mg,c,tp,minc,maxc,matg,ct,mustbemat) then
												table.insert(multi,1)
											end
											local eff={sc:GetCardEffect(511001225)}
											for i=1,#eff do
												local te=eff[i]
												local tgf=te:GetOperation()
												local val=te:GetValue()
												if val>0 and (not tgf or tgf(te,xyz)) then
													if minc>=ct+val 
														or mg:IsExists(Auxiliary.XyzRecursionChk2,1,nil,mg,c,tp,minc,maxc,matg,ct+val,mustbemat) then
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
										if ct>=minc and (not matg:IsExists(Card.IsHasEffect,1,nil,91110378) or Auxiliary.MatNumChkF(matg)) then
											cancel=true
										else
											cancel=not og and Duel.GetCurrentChain()<=0
										end
									end
								end
								matg:KeepAlive()
								e:SetLabelObject(matg)
								return true
							end
						end
					end
					return false
				end
			end
end
function Auxiliary.XyzOperation(f,lv,minc,maxc,mustbemat)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local g=e:GetLabelObject()
				if not g then return end
				local remg=g:Filter(Card.IsHasEffect,nil,511002116)
				remg:ForEach(function(c) c:RegisterFlagEffect(511002115,RESET_EVENT+0x1fe0000,0,0) end)
				g:Remove(Card.IsHasEffect,nil,511002116)
				g:Remove(Card.IsHasEffect,nil,511002115)
				local sg=Group.CreateGroup()
				for tc in aux.Next(g) do
					local sg1=tc:GetOverlayGroup()
					sg:Merge(sg1)
				end
				Duel.SendtoGrave(sg,REASON_RULE)
				c:SetMaterial(g)
				Duel.Overlay(c,g:Filter(function(c) return c:GetEquipTarget() end,nil))
				Duel.Overlay(c,g)
				g:DeleteGroup()
			end
end
--Xyz summon(alterf)
function Auxiliary.XyzCondition2(alterf,op)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
				end
				return (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
			end
end
function Auxiliary.XyzTarget2(alterf,op)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				local cancel=not og and Duel.GetCurrentChain()<=0
				if cancel then
					Auxiliary.ProcCancellable=true
				end
				if op then if not op(e,tp,1) then return false end cancel=false end
				if og and not min then
					og:KeepAlive()
					e:SetLabelObject(og)
					return true
				else
					local mg=nil
					if og then
						mg=og
					else
						mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
					end
					local minct=cancel and 0 or 1
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,minct,1,nil,alterf,c,e,tp,op)
					if g:GetCount()>0 then
						if op then op(e,tp,2,g:GetFirst()) end
						g:KeepAlive()
						e:SetLabelObject(g)
						return true
					else return false end
				end
			end
end	
function Auxiliary.XyzOperation2(alterf,op)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local g=e:GetLabelObject()
				local mg2=g:GetFirst():GetOverlayGroup()
				if mg2:GetCount()~=0 then
					Duel.Overlay(c,mg2)
				end
				c:SetMaterial(g)
				Duel.Overlay(c,g)
				g:DeleteGroup()
			end
end
