--Number F0: Future Hope
function c511000192.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	c511000192.xyz_filter=function(mc,ignoretoken) return mc:IsType(TYPE_XYZ) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
	c511000192.minxyzct=2
	c511000192.maxxyzct=2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c511000192.xyzcon)
	e1:SetTarget(c511000192.xyztg)
	e1:SetOperation(c511000192.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--rank
	c:SetStatus(STATUS_NO_LEVEL,true)
	--indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage val
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511000192,0))
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetTarget(c511000192.atktg)
	e5:SetOperation(c511000192.atkop)
	c:RegisterEffect(e5)
	--prevent destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(59251766,0))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c511000192.cost)
	e7:SetOperation(c511000192.op2)
	c:RegisterEffect(e7)
	--prevent effect damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(20450925,0))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c511000192.cost)
	e8:SetOperation(c511000192.op3)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCode(511002571)
	e9:SetLabelObject(e7)
	e9:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e10:SetCode(511002571)
	e10:SetLabelObject(e8)
	e10:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e10)
	if not c511000192.global_check then
		c511000192.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511000192.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c511000192.xyz_number=0
function c511000192.ovfilter2(c,xyz,tp)
	if c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(511002793) then return false end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	return c511000192.ovfilter1(c,xyz,tp)
end
function c511000192.ovfilter1(c,xyz,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyz) and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
function c511000192.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c511000192.ovfilter1,nil,c,tp)
	else
		mg=Duel.GetMatchingGroup(c511000192.ovfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,c,tp)
		local eqg=mg:Filter(aux.XyzFreeMatFilter,nil)
		local eqmg=Group.CreateGroup()
		local tc=eqg:GetFirst()
		while tc do
			local eq=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
			eqmg:Merge(eq)
			tc=eqg:GetNext()
		end
		mg:Merge(eqmg)
	end
	local minusg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116)
	local minc=2-minusg:GetCount()
	local maxc=2-minusg:GetCount()
	local sg=mg:Filter(aux.XyzFreeMatFilter,nil)
	if (not min or min==99 or (sg:GetCount()>=min and min>=minc)) and sg:GetCount()>=minc 
		and (Duel.GetLocationCountFromEx(tp)>0 or sg:IsExists(aux.FieldChk,1,nil,tp,c)) then return true end
	if not mg:IsExists(aux.NeedRecursionXyz,1,nil,73941492+TYPE_XYZ,91110378,511001225) then return false end
	if mg:IsExists(aux.CheckMultiXyzMaterial,1,nil,c) then
		minc=minc+minusg:GetCount()
		maxc=maxc+minusg:GetCount()
		mg:Merge(minusg)
	end
	if min and min~=99 then
		return mg:IsExists(aux.XyzRecursionChk1,1,nil,mg,c,tp,min,max,minc,maxc,Group.CreateGroup(),0,0,false)
	else
		return mg:IsExists(aux.XyzRecursionChk2,1,nil,mg,c,tp,minc,maxc,Group.CreateGroup(),0,false)
	end
	return false
end
function c511000192.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
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
				local sg=mg:FilterSelect(tp,aux.XyzRecursionChk1,1,1,nil,mg,c,tp,min,max,2,2,matg,ct,matct,false)
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
						if mg:IsExists(aux.XyzRecursionChk1,1,nil,mg,c,tp,min,max,2,2,matg,ct,matct+1,false) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and (not tgf or tgf(te,xyz)) then
								if (min>=ct and minct>=matct+1+val) 
									or mg:IsExists(aux.XyzRecursionChk1,1,nil,mg,c,tp,min,max,2,2,matg,ct,matct+1+val,false) then
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
		return false
	else
		local mg
		local cancel=true
		if og then
			mg=og:Filter(c511000192.ovfilter1,nil,c,tp)
			cancel=false
		else
			mg=Duel.GetMatchingGroup(c511000192.ovfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,c,tp)
			local eqg=mg:Filter(aux.XyzFreeMatFilter,nil)
			local eqmg=Group.CreateGroup()
			local tc=eqg:GetFirst()
			while tc do
				local eq=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
				eqmg:Merge(eq)
				tc=eqg:GetNext()
			end
			mg:Merge(eqmg)
			if Duel.GetCurrentChain()>0 then cancel=false end
		end
		mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
		if not og or min==99 then
			local multichkg=mg:Filter(aux.CheckValidMultiXyzMaterial,nil,c)
			local multichkg2=multichkg:Filter(aux.CheckMultiXyzMaterial,nil,c)
			if not mg:IsExists(aux.NeedRecursionXyz,1,nil,73941492+TYPE_XYZ,91110378) 
				or (not mg:IsExists(aux.CheckRecursionCode,1,nil,73941492+TYPE_XYZ,mg,c,tp,2,2,Group.CreateGroup(),0,false) 
				and not mg:IsExists(aux.CheckRecursionCode,1,nil,91110378,mg,c,tp,2,2,Group.CreateGroup(),0,false)
				and not multichkg2:IsExists(aux.CheckRecursionCode,1,nil,511001225,mg,c,tp,2,2,Group.CreateGroup(),0,false)) then
				mg=mg:Filter(function(c) return not c:IsHasEffect(73941492+TYPE_XYZ) and not c:IsHasEffect(91110378) end,nil)
				if not mg:IsExists(Card.IsHasEffect,1,nil,511001175) and not multichkg:IsExists(aux.Check2XyzMaterial,1,nil,c) then
					local matg=Group.CreateGroup()
					while matg<2 do
						local tc
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
						if Duel.GetLocationCountFromEx(tp)>0 or matg:IsExists(aux.FieldChk,1,nil,tp,c) then
							tc=Group.SelectUnselect(mg,matg,tp,cancel,cancel)
						else
							tc=Group.SelectUnselect(mg:Filter(aux.FieldChk,matg,tp,c),matg,tp,cancel,cancel)
						end
						if not tc then return false end
						if matg:IsContains(tc) then
							matg:RemoveCard(tc)
							mg:AddCard(tc)
						else
							matg:AddCard(tc)
							mg:RemoveCard(tc)
						end
					end
					matg:KeepAlive()
					e:SetLabelObject(matg)
					return true
				else
					local ft=Duel.GetLocationCountFromEx(tp)
					mg:Remove(Card.IsHasEffect,nil,511001175)
					local ct=0
					local matg=Group.CreateGroup()
					while ct<2 do
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
						local tc
						if matg:IsExists(aux.FieldChk,1,nil,tp,c) then
							tc=Group.SelectUnselect(mg,matg:Filter(function(rc) return rc:GetFlagEffect(511001226)==0 end,nil),tp,cancel,cancel)
						else
							tc=Group.SelectUnselect(mg:Filter(aux.FieldChk,matg,tp,c),matg:Filter(function(rc) return rc:GetFlagEffect(511001226)==0 end,nil),tp,cancel,cancel)
						end
						if not tc then return false end
						if mg:IsContains(tc) then
							mg:Merge(tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175))
							if not aux.Check2XyzMaterial(tc,c) or tc:GetFlagEffect(511001226)>0 then
								mg:RemoveCard(tc)
							else
								tc:RegisterFlagEffect(511001226,RESET_EVENT+0x1fe0000,0,0)
							end
							matg:AddCard(tc)
							ct=ct+1
						end
					end
					matg:KeepAlive()
					e:SetLabelObject(matg)
					return true
				end
			end
		else
			local ct=0
			local tempg=Group.CreateGroup()
			local matg=Group.CreateGroup()
			local g=Group.CreateGroup()
			while ct<2 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sc=Group.SelectUnselect(mg:Filter(aux.XyzRecursionChk2,g,mg,c,tp,2,2,matg,ct,false),g,tp,cancel,cancel)
				if not sc then return false end
				if not matg:IsContains(sc) then
					mg:RemoveCard(sc)
					g:AddCard(sc)
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
						if mg:IsExists(aux.XyzRecursionChk2,1,nil,mg,c,tp,2,2,matg,ct,false) then
							table.insert(multi,1)
						end
						local eff={sc:GetCardEffect(511001225)}
						for i=1,#eff do
							local te=eff[i]
							local tgf=te:GetOperation()
							local val=te:GetValue()
							if val>0 and (not tgf or tgf(te,xyz)) then
								if 2>=ct+val 
									or mg:IsExists(aux.XyzRecursionChk2,1,nil,mg,c,tp,2,2,matg,ct+val,false) then
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
			matg:KeepAlive()
			e:SetLabelObject(matg)
			return true
		end
	end
	return false
end
function c511000192.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
	Duel.Overlay(c,sg)
	c:SetMaterial(g)
	Duel.Overlay(c,g:Filter(function(c) return c:GetEquipTarget() end,nil))
	Duel.Overlay(c,g)
	g:DeleteGroup()
end
function c511000192.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,bc,1,0,0)
end
function c511000192.atkop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.GetControl(bc,tp,PHASE_BATTLE,1)
	end
end
function c511000192.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511000192.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
	end
end
function c511000192.op3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c511000192.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function c511000192.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c511000192.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,65305468)
	Duel.CreateToken(1-tp,65305468)
end
