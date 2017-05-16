Auxiliary={}
aux=Auxiliary
POS_FACEUP_DEFENCE=POS_FACEUP_DEFENSE
POS_FACEDOWN_DEFENCE=POS_FACEDOWN_DEFENSE

function Auxiliary.Stringid(code,id)
	return code*16+id
end
function Auxiliary.Next(g)
	local first=true
	return	function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
function Auxiliary.NULL()
end
function Auxiliary.TRUE()
	return true
end
function Auxiliary.FALSE()
	return false
end
function Auxiliary.AND(f1,f2)
	return	function(a,b,c)
				return f1(a,b,c) and f2(a,b,c)
			end
end
function Auxiliary.OR(f1,f2)
	return	function(a,b,c)
				return f1(a,b,c) or f2(a,b,c)
			end
end
function Auxiliary.NOT(f)
	return	function(a,b,c)
				return not f(a,b,c)
			end
end
function Auxiliary.BeginPuzzle(effect)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TURN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(Auxiliary.PuzzleOp)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_DP)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_SKIP_SP)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,0)
end
function Auxiliary.PuzzleOp(e,tp)
	Duel.SetLP(0,0)
end
function Auxiliary.IsDualState(effect)
	local c=effect:GetHandler()
	return not c:IsDisabled() and c:IsDualState()
end
function Auxiliary.IsNotDualState(effect)
	local c=effect:GetHandle()
	return c:IsDisabled() or not c:IsDualState()
end
function Auxiliary.DualNormalCondition(effect)
	local c=effect:GetHandler()
	return c:IsFaceup() and not c:IsDualState()
end
function Auxiliary.EnableDualAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(aux.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
end
--register effect of return to hand for Spirit monsters
function Auxiliary.EnableSpiritReturn(c,event1,...)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(Auxiliary.SpiritReturnReg)
	c:RegisterEffect(e1)
	for i,event in ipairs{...} do
		local e2=e1:Clone()
		e2:SetCode(event)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(Auxiliary.SpiritReturnCondition)
	e1:SetTarget(Auxiliary.SpiritReturnTarget)
	e1:SetOperation(Auxiliary.SpiritReturnOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function Auxiliary.SpiritReturnCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function Auxiliary.SpiritReturnTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function Auxiliary.SpiritReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function Auxiliary.IsUnionState(effect)
	local c=effect:GetHandler()
	return c:IsHasEffect(EFFECT_UNION_STATUS)
end
function Auxiliary.SetUnionState(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNION_STATUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	if c.old_union then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_OLDUNION_STATUS)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.CheckUnionEquip(uc,tc)
	ct1,ct2=tc:GetUnionCount()
	if uc.old_union then return ct1==0
	else return ct2==0 end
end
function Auxiliary.TargetEqualFunction(f,value,a,b,c)
	return	function(effect,target)
				return f(target,a,b,c)==value
			end
end
function Auxiliary.TargetBoolFunction(f,a,b,c)
	return	function(effect,target)
				return f(target,a,b,c)
			end
end
function Auxiliary.FilterEqualFunction(f,value,a,b,c)
	return	function(target)
				return f(target,a,b,c)==value
			end
end
function Auxiliary.FilterBoolFunction(f,a,b,c)
	return	function(target)
				return f(target,a,b,c)
			end
end
function Auxiliary.NonTuner(f,a,b,c)
	return	function(target)
				return target:IsNotTuner() and (not f or f(target,a,b,c))
			end
end
--Synchro monster, 1 tuner + n or more monsters
function Auxiliary.AddSynchroProcedure(c,f1,f2,ct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
	e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
	e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Auxiliary.SynCondition(f1,f2,minc,maxc)
	return	function(e,c,smat,mg)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			end
end
function Auxiliary.SynTarget(f1,f2,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg)
				local g=nil
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.SynOperation(f1,f2,minct,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
--Synchro monster, 1 tuner + 1 monster
function Auxiliary.AddSynchroProcedure2(c,f1,f2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynCondition(f1,f2,1,1))
	e1:SetTarget(Auxiliary.SynTarget(f1,f2,1,1))
	e1:SetOperation(Auxiliary.SynOperation(f1,f2,1,1))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Auxiliary.XyzAlterFilter(c,alterf,xyzc,tp)
	return alterf(c) and c:IsCanBeXyzMaterial(xyzc) and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
--Xyz monster, lv k*n
function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op,mustbemat)
	--mustbemat for Startime Magician
	if not maxct then maxct=ct end	
	if c.xyz_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.xyz_filter=function(mc,ignoretoken) return mc and (not f or f(mc)) and mc:IsXyzLevel(c,lv) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
		mt.minxyzct=ct
		mt.maxxyzct=maxct
	end
	
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
	local chkc=chkg:GetFirst()
		while chkc do
			local eff={chkc:GetCardEffect(91110378)}
			for j=1,#eff do
				local rct=eff[j]:GetValue()
				local comp=eff[j]:GetLabel()
				if not Auxiliary.MatNumChk(tg:FilterCount(Card.IsType,nil,TYPE_MONSTER),rct,comp) then return false end
			end
			chkc=chkg:GetNext()
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
						local tc=eqg:GetFirst()
						while tc do
							local eq=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
							eqmg:Merge(eq)
							tc=eqg:GetNext()
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
						while ct<min or matct<minc do
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
							local sg=mg:FilterSelect(tp,Auxiliary.XyzRecursionChk1,1,1,nil,mg,c,tp,min,max,minc,maxc,matg,ct,matct,mustbemat)
							local sc=sg:GetFirst()
							mg:RemoveCard(sc)
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
					return false
				else
					local xg=nil
					if tp==0 then
						xg=xyztempg0
					else
						xg=xyztempg1
					end
					local mg
					if og then
						mg=og:Filter(Auxiliary.XyzMatFilter,nil,f,lv,c,tp)
					else
						mg=Duel.GetMatchingGroup(Auxiliary.XyzMatFilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,f,lv,c,tp)
						if not mustbemat then
							local eqg=mg:Filter(Auxiliary.XyzFreeMatFilter,nil)
							local eqmg=Group.CreateGroup()
							local tc=eqg:GetFirst()
							while tc do
								local eq=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
								eqmg:Merge(eq)
								tc=eqg:GetNext()
							end
							mg:Merge(eqmg)
							mg:Merge(Duel.GetMatchingGroup(Auxiliary.XyzSubMatFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,f,lv,xg))
						end
					end
					if not mustbemat then
						mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,511002116))
					end
					if not og or min==99 then
						if mustbemat then
							if not mg:IsExists(Auxiliary.NeedRecursionXyz,1,nil,73941492+TYPE_XYZ,91110378) 
								or (not mg:IsExists(Auxiliary.CheckRecursionCode,1,nil,73941492+TYPE_XYZ,mg,c,tp,minc,maxc,Group.CreateGroup(),0,mustbemat) 
								and not mg:IsExists(Auxiliary.CheckRecursionCode,1,nil,91110378,mg,c,tp,minc,maxc,Group.CreateGroup(),0,mustbemat)) then
								local matg
								if Duel.GetLocationCountFromEx(tp)>0 then
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
									matg=mg:Select(tp,minc,maxc,nil)
								else
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
									matg=mg:FilterSelect(tp,Auxiliary.FieldChk,1,1,nil,tp,c)
									if minc>1 then
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
										mg2=mg:Select(tp,minc-1,maxc-1,matg:GetFirst())
										matg:Merge(mg2)
									end
								end
								matg:KeepAlive()
								e:SetLabelObject(matg)
								return true
							else
								local matg=Group.CreateGroup()
								local ct=0
								while (matg:IsExists(Card.IsHasEffect,1,nil,91110378) and not Auxiliary.MatNumChkF(matg)) 
									or ct<minc or (mg:IsExists(Auxiliary.XyzRecursionChk2,1,nil,mg,c,tp,minc,maxc,matg,ct,mustbemat) and Duel.SelectYesNo(tp,513)) do
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
									local sg=mg:FilterSelect(tp,Auxiliary.XyzRecursionChk2,1,1,nil,mg,c,tp,minc,maxc,matg,ct,mustbemat)
									local sc=sg:GetFirst()
									mg:RemoveCard(sc)
									matg:AddCard(sc)
									if sc:IsHasEffect(73941492+TYPE_XYZ) then
										local eff={sc:GetCardEffect(73941492+TYPE_XYZ)}
										for i=1,#eff do
											local f=eff[i]:GetValue()
											mg=mg:Filter(Auxiliary.TuneMagFilterXyz,sc,eff[i],f)
										end
									end
									ct=ct+1
								end
								matg:KeepAlive()
								e:SetLabelObject(matg)
								return true
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
									--no multi material and no Equip Material
									local matg
									if Duel.GetLocationCountFromEx(tp)>0 then
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
										matg=mg:Select(tp,minc,maxc,nil)
									else
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
										matg=mg:FilterSelect(tp,Auxiliary.FieldChk,1,1,nil,tp,c)
										if minc>1 then
											Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
											mg2=mg:Select(tp,minc-1,maxc-1,matg:GetFirst())
											matg:Merge(mg2)
										end
									end
									matg:KeepAlive()
									e:SetLabelObject(matg)
									return true
								else
									local ft=Duel.GetLocationCountFromEx(tp)
									mg:Remove(Card.IsHasEffect,nil,511001175)
									local matg=Group.CreateGroup()
									for i=1,minc do
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
										local sg
										if ft>0 then
											sg=mg:Select(tp,1,1,nil)
										else
											sg=mg:FilterSelect(tp,Auxiliary.FieldChk,1,1,nil,tp,c)
											ft=1
										end
										local sc=sg:GetFirst()
										mg:Merge(sc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175))
										if not Auxiliary.Check2XyzMaterial(sc,c) or sc:GetFlagEffect(511001226)>0 then
											mg:RemoveCard(sc)
										else
											--2 xyz material monsters can be selected twice
											sc:RegisterFlagEffect(511001226,RESET_EVENT+0x1fe0000,0,0)
										end
										matg:AddCard(sc)
									end
									local ct=minc
									if ct<maxc and mg:GetCount()>0 and Duel.SelectYesNo(tp,513) then
										repeat
											Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
											local sg=mg:Select(tp,1,1,nil)
											local sc=sg:GetFirst()
											mg:Merge(sc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175))
											mg:RemoveCard(sc)
											matg:AddCard(sc)
											ct=ct+1
										until ct>=maxc or mg:GetCount()<=0 or not Duel.SelectYesNo(tp,513)
									end
									matg:KeepAlive()
									e:SetLabelObject(matg)
									return true
								end
							else
								local ct=0
								local tempg=Group.CreateGroup()
								local matg=Group.CreateGroup()
								while (matg:IsExists(Card.IsHasEffect,1,nil,91110378) and not Auxiliary.MatNumChkF(matg)) 
									or ct<minc or (mg:IsExists(Auxiliary.XyzRecursionChk2,1,nil,mg,c,tp,minc,maxc,matg,ct,mustbemat) and Duel.SelectYesNo(tp,513)) do
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
									local sg=mg:FilterSelect(tp,Auxiliary.XyzRecursionChk2,1,1,nil,mg,c,tp,minc,maxc,matg,ct,mustbemat)
									local sc=sg:GetFirst()
									mg:RemoveCard(sc)
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
end
--Xyz summon(alterf)
function Auxiliary.XyzCondition2(alterf,op)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				local ft=Duel.GetLocationCountFromEx(tp)
				local ct=-ft
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
				end
				return ct<1 and (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,tp)
					and (not op or op(e,tp,0))
			end
end
function Auxiliary.XyzTarget2(alterf,op)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if op then op(e,tp,1) end
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
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,tp)
					if g then
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
function Auxiliary.TuneMagFilterFus(c,e,f)
	return not f or f(e,c)
end
--material_count: number of different names in material list
--material: names in material list
--Fusion monster, mixed materials
function Auxiliary.AddFusionProcMix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub1,sub2) return (val[i](c) or (sub2 and c:IsHasEffect(511002961))) and not c:IsHasEffect(6205579) end
		else
			local addmat=true
			fun[i]=function(c,fc,sub1,sub2) return c:IsFusionCode(val[i]) or (sub1 and c:CheckFusionSubstitute(fc)) 
				or (sub2 and c:IsHasEffect(511002961)) end
			for index, value in ipairs(mat) do
				if value==val[i] then
					addmat=false
				end
			end
			if addmat then table.insert(mat,val[i]) end
		end
	end
	if c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if #mat>0 then
			mt.material_count=#mat
			mt.material=mat
		end
		--for cards that check number of required materials (Ultra Poly/ Ancient Gear Chaos Fusion)
		mt.min_material_count=#val
		mt.max_material_count=#val
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMix(insf,sub,table.unpack(fun)))
	e1:SetOperation(Auxiliary.FOperationMix(insf,sub,table.unpack(fun)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMix(insf,sub,...)
	--g:Material group(nil for Instant Fusion)
	--gc:Material already used
	--chkf: check field, default:PLAYER_NONE
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf end
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMix(gc,tp,mg,sg,c,sub,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.FSelectMix,1,nil,tp,mg,sg,c,sub,table.unpack(funs))
			end
end
function Auxiliary.FOperationMix(insf,sub,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				local sg=Group.CreateGroup()
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
				local p=tp
				local sfhchk=false
				if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
					p=1-tp Duel.ConfirmCards(1-tp,mg)
					if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
				end
				while sg:GetCount()<#funs do
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
					local tc=Group.SelectUnselect(mg:Filter(Auxiliary.FSelectMix,sg,tp,mg,sg,c,sub,table.unpack(funs)),sg,p)
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
							mg=mg:Filter(Auxiliary.TuneMagFilterFus,tc,eff[i],f)
						end
					end
				end
				if sfhchk then Duel.ShuffleHand(tp) end
				if gc then sg:RemoveCard(gc) end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FConditionFilterMix(c,fc,sub,...)
	if not c:IsCanBeFusionMaterial(fc) then return false end
	for i,f in ipairs({...}) do
		if f(c,fc,sub,sub) then return true end
	end
	return false
end
function Auxiliary.FCheckMix(c,mg,sg,fc,sub1,sub2,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		mg:RemoveCard(c)
		local res=false
		if fun1(c,fc,false,sub2) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,sub1,sub2,fun2,...)
		elseif sub1 and fun1(c,fc,true,sub2) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,false,sub2,fun2,...)
		end
		sg:RemoveCard(c)
		mg:AddCard(c)
		return res
	else
		return fun1(c,fc,sub1,sub2)
	end
end
Auxiliary.FCheckAdditional=nil
--if sg1 is subset of sg2 then not Auxiliary.FCheckAdditional(tp,sg1,fc) -> not Auxiliary.FCheckAdditional(tp,sg2,fc)
function Auxiliary.FCheckMixGoal(tp,sg,fc,sub,...)
	local g=Group.CreateGroup()
	return sg:IsExists(Auxiliary.FCheckMix,1,nil,sg,g,fc,sub,sub,...) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
end
function Auxiliary.FSelectMix(c,tp,mg,sg,fc,sub,...)
	sg:AddCard(c)
	mg:RemoveCard(c)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,eff[i],f) then
				mg:Merge(rg)
				return false
			end
			local sg2=sg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,eff[i],f) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	if sg:GetCount()<#{...} then
		res=mg:IsExists(Auxiliary.FSelectMix,1,sg,tp,mg,sg,fc,sub,...)
	else
		res=Auxiliary.FCheckMixGoal(tp,sg,fc,sub,...)
	end
	sg:RemoveCard(c)
	mg:AddCard(c)
	mg:Merge(rg)
	return res
end
--Fusion monster, mixed material * minc to maxc + material + ...
function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={fun1,...}
	local fun={}
	local mat={}
	local funs={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub1,sub2) return (val[i](c) or (sub2 and c:IsHasEffect(511002961))) and not c:IsHasEffect(6205579) end
		else
			local addmat=true
			fun[i]=function(c,fc,sub1,sub2) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) 
				or (sub2 and c:IsHasEffect(511002961)) end
			for index, value in ipairs(mat) do
				if value==val[i] then
					addmat=false
				end
			end
			if addmat then table.insert(mat,val[i]) end
		end
		if i~=1 then
			table.insert(funs,fun[i])
		end
	end
	for i=1,minc do
		table.insert(funs,fun[1])
	end
	if c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if #mat>0 then
			mt.material_count=#mat
			mt.material=mat
		end
		mt.min_material_count=minc+#{...}
		mt.max_material_count=maxc+#{...}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMix(insf,sub,table.unpack(funs)))
	e1:SetOperation(Auxiliary.FOperationMixRep(insf,sub,fun[1],maxc-minc,table.unpack(funs)))
	c:RegisterEffect(e1)
end
function Auxiliary.FOperationMixRep(insf,sub,fun1,extrac,...)
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local funs={...}
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				local sg=Group.CreateGroup()
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
				local p=tp
				local sfhchk=false
				if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
					p=1-tp Duel.ConfirmCards(1-tp,mg)
					if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
				end
				while sg:GetCount()<#funs do
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
					local tc=Group.SelectUnselect(mg:Filter(Auxiliary.FSelectMix,sg,tp,mg,sg,c,sub,table.unpack(funs)),sg,p)
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
							mg=mg:Filter(Auxiliary.TuneMagFilterFus,tc,eff[i],f)
						end
					end
				end
				local ct=1
				table.insert(funs,fun1)
				if extrac>0 and mg:IsExists(Auxiliary.FSelectMix,1,sg,tp,mg,sg,c,sub,table.unpack(funs)) 
					and Duel.SelectYesNo(p,511) then
					repeat
						Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
						local tc=mg:FilterSelect(p,Auxiliary.FSelectMix,1,1,sg,tp,mg,sg,c,sub,table.unpack(funs)):GetFirst()
						if tc:IsHasEffect(73941492+TYPE_FUSION) then
							local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
							for i=1,#eff do
								local f=eff[i]:GetValue()
								mg=mg:Filter(Auxiliary.TuneMagFilterFus,tc,eff[i],f)
							end
						end
						ct=ct+1
						table.insert(funs,fun1)
					until ct>extrac or not mg:IsExists(Auxiliary.FSelectMix,1,sg,tp,mg,sg,c,sub,table.unpack(funs)) 
						or not Duel.SelectYesNo(p,511)
						--table.remove(funs,#funs) --usable somewhere with unselect
				end
				if sfhchk then Duel.ShuffleHand(tp) end
				if gc then sg:RemoveCard(gc) end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FCheckMixRep(c,sg,g,fc,sub,fun1,minc,maxc,fun2,...)
	g:AddCard(c)
	local res=false
	if fun2 then
		if fun2(c,fc,sub) then
			local sub=sub and fun2(c,fc,false)
			res=sg:IsExists(Auxiliary.FCheckMixRep,1,g,sg,g,fc,sub,fun1,minc,maxc,...)
		end
	elseif fun1(c,fc,sub) then
		local sub=sub and fun1(c,fc,false)
		local ct1=sg:FilterCount(fun1,g,fc,sub)
		local ct2=sg:FilterCount(fun1,g,fc,false)
		res=ct1==sg:GetCount()-g:GetCount() and (not sub or ct1-ct2<=1)
	end
	g:RemoveCard(c)
	return res
end
function Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,fun1,minc,maxc,...)
	if sg:GetCount()<minc+#{...} or sg:GetCount()>maxc+#{...} then return false end
	local g=Group.CreateGroup()
	return sg:IsExists(Auxiliary.FCheckMixRep,1,nil,sg,g,fc,sub,fun1,minc,maxc,...) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
end
function Auxiliary.FCheckMixRepTemplate(c,cond,tp,mg,sg,g,fc,sub,fun1,minc,maxc,...)
	for i,f in ipairs({...}) do
		if f(c,fc,sub) then
			g:AddCard(c)
			local sub=sub and f(c,fc,false)
			local t={...}
			table.remove(t,i)
			local res=cond(tp,mg,sg,g,fc,sub,fun1,minc,maxc,table.unpack(t))
			g:RemoveCard(c)
			if res then return true end
		end
	end
	if maxc>0 then
		if fun1(c,fc,sub) then
			g:AddCard(c)
			local sub=sub and fun1(c,fc,false)
			local res=cond(tp,mg,sg,g,fc,sub,fun1,minc-1,maxc-1,...)
			g:RemoveCard(c)
			if res then return true end
		end
	end
	return false
end
function Auxiliary.FCheckMixRepSelectedCond(tp,mg,sg,g,...)
	if g:GetCount()<sg:GetCount() then
		return sg:IsExists(Auxiliary.FCheckMixRepSelected,1,g,tp,mg,sg,g,...)
	else
		return Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,...)
	end
end
function Auxiliary.FCheckMixRepSelected(c,...)
	return Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckMixRepSelectedCond,...)
end
function Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,fun1,minc,maxc,...)
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,g,fc) then return false end
	if Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 then
		if minc<=0 and #{...}==0 then return true end
		return mg:IsExists(Auxiliary.FCheckSelectMixRepAll,1,g,tp,mg,sg,g,fc,sub,fun1,minc,maxc,...)
	else
		return mg:IsExists(Auxiliary.FCheckSelectMixRepM,1,g,tp,mg,sg,g,fc,sub,fun1,minc,maxc,...)
	end
end
function Auxiliary.FCheckSelectMixRepAll(c,tp,mg,sg,g,fc,sub,fun1,minc,maxc,fun2,...)
	if fun2 then
		if fun2(c,fc,sub) then
			g:AddCard(c)
			local sub=sub and fun2(c,fc,false)
			local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,fun1,minc,maxc,...)
			g:RemoveCard(c)
			return res
		end
	elseif fun1(c,fc,sub) then
		g:AddCard(c)
		local sub=sub and fun1(c,fc,false)
		local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,fun1,minc-1,maxc-1)
		g:RemoveCard(c)
		return res
	end
end
function Auxiliary.FCheckSelectMixRepM(c,tp,...)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckSelectMixRep,tp,...)
end
function Auxiliary.FSelectMixRep(c,tp,mg,sg,fc,sub,...)
	sg:AddCard(c)
	local res=false
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then
		res=false
	elseif Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,...) then
		res=true
	else
		local g=Group.CreateGroup()
		res=sg:IsExists(Auxiliary.FCheckMixRepSelected,1,nil,tp,mg,sg,g,fc,sub,...)
	end
	sg:RemoveCard(c)
	return res
end
--Fusion monster, name + name
function Auxiliary.AddFusionProcCode2(c,code1,code2,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2)
end
--Fusion monster, name + name + name
function Auxiliary.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3)
end
--Fusion monster, name + name + name + name
function Auxiliary.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3,code4)
end
--Fusion monster, name * n
function Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	local code={}
	for i=1,cc do
		code[i]=code1
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(code))
end
--Fusion monster, name * minc to maxc
function Auxiliary.AddFusionProcCodeRep2(c,code1,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,code1,minc,maxc)
end
--Fusion monster, name + condition * n
function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,table.unpack(fun))
end
--Fusion monster, condition + condition
function Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
	Auxiliary.AddFusionProcMix(c,false,insf,f1,f2)
end
--Fusion monster, condition * n
function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,false,insf,table.unpack(fun))
end
--Fusion monster, condition * minc to maxc
function Auxiliary.AddFusionProcFunRep2(c,f,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f,minc,maxc)
end
--Fusion monster, condition1 + condition2 * n
function Auxiliary.AddFusionProcFunFun(c,f1,f2,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f2
	end
	Auxiliary.AddFusionProcMix(c,false,insf,f1,table.unpack(fun))
end
--Fusion monster, condition1 + condition2 * minc to maxc
function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f2,minc,maxc,f1)
end
--Fusion monster, name + condition * minc to maxc
function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1)
end
--Fusion monster, name + name + condition * minc to maxc
function Auxiliary.AddFusionProcCode2FunRep(c,code1,code2,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1,code2)
end
--Fusion monster, any number of name/condition * n - fixed
function Auxiliary.AddFusionProcMixN(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local t={}
	local n={}
	if #val%2~=0 then return end
	for i=1,#val do
		if i%2~=0 then
			table.insert(t,val[i])
		else
			table.insert(n,val[i])
		end
	end
	if #t~=#n then return end
	local fun={}
	for i=1,#t do
		for j=1,n[i] do
			table.insert(fun,t[i])
		end
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(fun))
end
--Ritual Summon, geq fixed lv
function Auxiliary.AddRitualProcGreater(c,filter)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPGTarget(filter))
	e1:SetOperation(Auxiliary.RPGOperation(filter))
	c:RegisterEffect(e1)
end
function Auxiliary.RPGFilter(c,filter,e,tp,m,ft)
	if (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetOriginalLevel(),c)
	else
		return mg:IsExists(Auxiliary.RPGFilterF,1,nil,tp,mg,c)
	end
end
function Auxiliary.RPGFilterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetOriginalLevel(),rc)
	else return false end
end
function Auxiliary.RPGTarget(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
					return ft>-1 and Duel.IsExistingMatchingCard(Auxiliary.RPGFilter,tp,LOCATION_HAND,0,1,nil,filter,e,tp,mg,ft)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
			end
end
function Auxiliary.RPGOperation(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.RPGFilter,tp,LOCATION_HAND,0,1,1,nil,filter,e,tp,mg,ft)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					local mat=nil
					if ft>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),tc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:FilterSelect(tp,Auxiliary.RPGFilterF,1,1,nil,tp,mg,tc)
						Duel.SetSelectedCard(mat)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),tc)
						mat:Merge(mat2)
					end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end
function Auxiliary.AddRitualProcGreaterCode(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1}
	end
	Auxiliary.AddRitualProcGreater(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1))
end
--Ritual Summon, equal to fixed lv
function Auxiliary.AddRitualProcEqual(c,filter)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPETarget(filter))
	e1:SetOperation(Auxiliary.RPEOperation(filter))
	c:RegisterEffect(e1)
end
function Auxiliary.RPEFilter(c,filter,e,tp,m,ft)
	if (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetOriginalLevel(),1,99,c)
	else
		return mg:IsExists(Auxiliary.RPEFilterF,1,nil,tp,mg,c)
	end
end
function Auxiliary.RPEFilterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetOriginalLevel(),0,99,rc)
	else return false end
end
function Auxiliary.RPETarget(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
					return ft>-1 and Duel.IsExistingMatchingCard(Auxiliary.RPEFilter,tp,LOCATION_HAND,0,1,nil,filter,e,tp,mg,ft)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
			end
end
function Auxiliary.RPEOperation(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.RPEFilter,tp,LOCATION_HAND,0,1,1,nil,filter,e,tp,mg,ft)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					local mat=nil
					if ft>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),1,99,tc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:FilterSelect(tp,Auxiliary.RPEFilterF,1,1,nil,tp,mg,tc)
						Duel.SetSelectedCard(mat)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),0,99,tc)
						mat:Merge(mat2)
					end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end
function Auxiliary.AddRitualProcEqualCode(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1}
	end
	Auxiliary.AddRitualProcEqual(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1))
end
--Ritual Summon, equal to monster lv
function Auxiliary.AddRitualProcEqual2(c,filter)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPETarget2(filter))
	e1:SetOperation(Auxiliary.RPEOperation2(filter))
	c:RegisterEffect(e1)
end
function Auxiliary.RPEFilter2(c,filter,e,tp,m,ft)
	if (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return mg:IsExists(Auxiliary.RPEFilter2F,1,nil,tp,mg,c)
	end
end
function Auxiliary.RPEFilter2F(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function Auxiliary.RPETarget2(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
					return ft>-1 and Duel.IsExistingMatchingCard(Auxiliary.RPEFilter2,tp,LOCATION_HAND,0,1,nil,filter,e,tp,mg,ft)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
			end
end
function Auxiliary.RPEOperation2(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.RPEFilter2,tp,LOCATION_HAND,0,1,1,nil,filter,e,tp,mg,ft)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					local mat=nil
					if ft>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:FilterSelect(tp,Auxiliary.RPEFilter2F,1,1,nil,tp,mg,tc)
						Duel.SetSelectedCard(mat)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
						mat:Merge(mat2)
					end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end
function Auxiliary.AddRitualProcEqual2Code(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1}
	end
	Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1))
end
function Auxiliary.AddRitualProcEqual2Code2(c,code1,code2)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1,code2}
	end
	Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1,code2))
end
--add procedure to Pendulum monster, also allows registeration of activation effect
function Auxiliary.EnablePendulumAttribute(c,reg)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(Auxiliary.PendCondition())
	e1:SetOperation(Auxiliary.PendOperation())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.PConditionFilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and ((lv>lscale and lv<rscale) or c:IsHasEffect(511004423)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end
function Auxiliary.PendCondition()
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(Auxiliary.PConditionFilter,1,nil,e,tp,lscale,rscale)
			end
end
function Auxiliary.PendOperation()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp)
				local ft=Duel.GetUsableMZoneCount(tp)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				local loc=0
				if ft1>0 then loc=loc+LOCATION_HAND end
				if ft2>0 then loc=loc+LOCATION_EXTRA end
				local tg=nil
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PConditionFilter,nil,e,tp,lscale,rscale)
				else
					tg=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale)
				end
				ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
				ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				while true do
					local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
					local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
					local ct=ft
					if ct1>ft1 then ct=math.min(ct,ft1) end
					if ct2>ft2 then ct=math.min(ct,ft2) end
					if ct<=0 then break end
					if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=tg:Select(tp,1,ct,nil)
					tg:Sub(g)
					sg:Merge(g)
					if g:GetCount()<ct then ft=0 break end
					ft=ft-g:GetCount()
					ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
					ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
				end
				if ft>0 then
					local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
					local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
					if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
						local ct=math.min(ft1,ft)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local g=tg1:Select(tp,1,ct,nil)
						sg:Merge(g)
					end
					if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
						local ct=math.min(ft2,ft)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local g=tg2:Select(tp,1,ct,nil)
						sg:Merge(g)
					end
				end
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
			end
end
--Link Summon
function Auxiliary.AddLinkProcedure(c,f,min,max)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max))
	e1:SetTarget(Auxiliary.LinkTarget(f,min,max))
	e1:SetOperation(Auxiliary.LinkOperation(f,min,max))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--link limitations
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_TURN_SET)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(Auxiliary.LinkSpLimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	c:RegisterEffect(e5)
end
function Auxiliary.LinkSpLimit(e,se,sp,st)
	return bit.band(sp,POS_ATTACK)>0
end
function Auxiliary.LConditionFilter(c,f)
	return c:IsFaceup() and (not f or f(c))
end
function Auxiliary.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function Auxiliary.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.LCheckGoal(tp,sg,lc,minc,ct)
		or (ct<maxc and mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.LCheckGoal(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Auxiliary.LinkCondition(f,minc,maxc)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f)
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.LCheckRecursive,1,nil,tp,sg,mg,c,0,minc,maxc)
			end
end
function Auxiliary.LinkTarget(f,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f)
				local sg=Group.CreateGroup()
				local i=0
				local cancel=false
				while i<maxc do
					local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc)
					if cg:GetCount()==0 then break end
					if i>minc and i<=maxc and Auxiliary.LCheckGoal(tp,sg,c,minc,i) then
						cancel=true 
					else 
						cancel=false
					end
					local tc=Group.SelectUnselect(cg,sg,tp,cancel,i==0 or cancel,1,1)
					if not tc then break end
					if not sg:IsContains(tc) then
						sg:AddCard(tc)
						i=i+1
					else
						sg:RemoveCard(tc)
						i=i-1
					end
				end
				if sg:GetCount()>0 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function Auxiliary.LinkOperation(f,min,max)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function Auxiliary.IsMaterialListCode(c,code)
	if not c.material then return false end
	for i,mcode in ipairs(c.material) do
		if code==mcode then return true end
	end
	return false
end
function Auxiliary.IsMaterialListSetCard(c,setcode)
	return c.material_setcode and c.material_setcode==setcode
end
function Auxiliary.IsCodeListed(c,code)
	if not c.card_code_list then return false end
	for i,ccode in ipairs(c.card_code_list) do
		if code==ccode then return true end
	end
	return false
end
--card effect disable filter(target)
function Auxiliary.disfilter1(c)
	return c:IsFaceup() and not c:IsDisabled() and (not c:IsType(TYPE_NORMAL) or bit.band(c:GetOriginalType(),TYPE_EFFECT)~=0)
end
--condition of EVENT_BATTLE_DESTROYING
function Auxiliary.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
--condition of EVENT_BATTLE_DESTROYING + opponent monster
function Auxiliary.bdocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
--condition of EVENT_BATTLE_DESTROYING + to_grave
function Auxiliary.bdgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
--condition of EVENT_BATTLE_DESTROYING + opponent monster + to_grave
function Auxiliary.bdogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
--condition of EVENT_TO_GRAVE + destroyed_by_opponent_from_field
function Auxiliary.dogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY) and rp~=tp
end
--condition of "except the turn this card was sent to the Graveyard"
function Auxiliary.exccon(e)
	return Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)
end
--flag effect for spell counter
function Auxiliary.chainreg(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)==0 then
		e:GetHandler():RegisterFlagEffect(1,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
end
--default filter for EFFECT_CANNOT_BE_BATTLE_TARGET
function Auxiliary.imval1(e,c)
	return not c:IsImmuneToEffect(e)
end
--filter for EFFECT_CANNOT_BE_EFFECT_TARGET + opponent 
function Auxiliary.tgoval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
--filter for non-zero ATK 
function Auxiliary.nzatk(c)
	return c:IsFaceup() and c:GetAttack()>0
end
--filter for non-zero DEF
function Auxiliary.nzdef(c)
	return c:IsFaceup() and c:GetDefense()>0
end
--flag effect for summon/sp_summon turn
function Auxiliary.sumreg(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local code=e:GetLabel()
	while tc do
		if tc:GetOriginalCode()==code then 
			tc:RegisterFlagEffect(code,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1) 
		end
		tc=eg:GetNext()
	end
end
--sp_summon condition for fusion monster
function Auxiliary.fuslimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
--sp_summon condition for ritual monster
function Auxiliary.ritlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
--sp_summon condition for synchro monster
function Auxiliary.synlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
--sp_summon condition for xyz monster
function Auxiliary.xyzlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
--sp_summon condition for pendulum monster
function Auxiliary.penlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--effects inflicting damage to tp
function Auxiliary.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) then 
		return true 
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE)
end
--filter for the immune effect of qli monsters
function Auxiliary.qlifilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	else
		return false
	end
end
--filter for necro_valley test
function Auxiliary.nvfilter(c)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function Auxiliary.NecroValleyFilter(f)
	return	function(target,...)
				return f(target,...) and not (target:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0))
			end
end

--Function to check the summon method used for the card. Credit goes to Cute-Nekomimi
function Card.IsSummonType(c,t)
	return bit.band(c:GetSummonType(),t)==t
end
--Cost for effect "You can banish this card from your Graveyard"
function Auxiliary.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

--add procedure to equip spells equipping by rule
function Auxiliary.AddEquipProcedure(c,p,f,eqlimit,cost,tg,op,con)
	--Note: p==0 is check equip spell controler, p==1 for opponent's, PLAYER_ALL for both player's monsters
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	if con then
		e1:SetCondition(con)
	end
	if cost~=nil then
		e1:SetCost(cost)
	end
	e1:SetTarget(Auxiliary.EquipTarget(tg,p,f))
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	if eqlimit~=nil then
		e2:SetValue(eqlimit)
	else
		e2:SetValue(Auxiliary.EquipLimit(f))
	end
	c:RegisterEffect(e2)
end
function Auxiliary.EquipLimit(f)
	return function(e,c)
				return not f or f(c,e,e:GetHandlerPlayer())
			end
end
function Auxiliary.EquipFilter(c,p,f,e,tp)
	return (p==PLAYER_ALL or c:IsControler(p)) and c:IsFaceup() and (not f or f(c,e,tp))
end
function Auxiliary.EquipTarget(tg,p,f)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local player=nil
				if p==0 then
					player=tp
				elseif p==1 then
					player=1-tp
				elseif p==PLAYER_ALL or p==nil then
					player=PLAYER_ALL
				end
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and Auxiliary.EquipFilter(chkc,player,f,e,tp) end
				if chk==0 then return player~=nil and Duel.IsExistingTarget(Auxiliary.EquipFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,player,f,e,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local g=Duel.SelectTarget(tp,Auxiliary.EquipFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,player,f,e,tp)
				if tg then tg(e,tp,eg,ep,ev,re,r,rp,g:GetFirst()) end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_SOLVING)
				e1:SetReset(RESET_CHAIN)
				e1:SetLabel(Duel.GetCurrentChain())
				e1:SetLabelObject(e)
				e1:SetOperation(Auxiliary.EquipEquip)
				Duel.RegisterEffect(e1,tp)
				Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
			end
end
function Auxiliary.EquipEquip(e,tp,eg,ep,ev,re,r,rp)
	if re~=e:GetLabelObject() then return end
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS):GetFirst()
	if tc and c:IsRelateToEffect(re) and tc:IsRelateToEffect(re) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

--add procedure to persistent traps
function Auxiliary.AddPersistentProcedure(c,p,f,category,property,hint1,hint2,con,cost,tg,op,anypos)
	--Note: p==0 is check persistent trap controler, p==1 for opponent's, PLAYER_ALL for both player's monsters
	--anypos is check for face-up/any
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	if category then
		e1:SetCategory(category)
	end
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	if hint1 or hint2 then
		if hint1==hint2 then
			e1:SetHintTiming(hint)
		elseif hint1 and not hint2 then
			e1:SetHintTiming(hint1,0)
		elseif hint2 and not hint1 then
			e1:SetHintTiming(0,hint2)
		else
			e1:SetHintTiming(hint1,hint2)
		end
	end
	if property then
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+property)
	else
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if con then
		e1:SetCondition(con)
	end
	if cost then
		e1:SetCost(cost)
	end
	e1:SetTarget(Auxiliary.PersistentTarget(tg,p,f))
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabelObject(e1)
	e2:SetCondition(Auxiliary.PersistentTgCon)
	e2:SetOperation(Auxiliary.PersistentTgOp(anypos))
	c:RegisterEffect(e2)
end
function Auxiliary.PersistentFilter(c,p,f,e,tp)
	return (p==PLAYER_ALL or c:IsControler(p)) and (not f or f(c,e,tp))
end
function Auxiliary.PersistentTarget(tg,p,f)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local player=nil
				if p==0 then
					player=tp
				elseif p==1 then
					player=1-tp
				elseif p==PLAYER_ALL or p==nil then
					player=PLAYER_ALL
				end
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and Auxiliary.PersistentFilter(chkc,player,f,e,tp) end
				if chk==0 then return player~=nil and Duel.IsExistingTarget(Auxiliary.PersistentFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,player,f,e,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local g=Duel.SelectTarget(tp,Auxiliary.PersistentFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,player,f,e,tp)
				if tg then tg(e,tp,eg,ep,ev,re,r,rp,g:GetFirst()) end
			end
end
function Auxiliary.PersistentTgCon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function Auxiliary.PersistentTgOp(anypos)
	return function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
			if c:IsRelateToEffect(re) and tc and (anypos or tc:IsFaceup()) and tc:IsRelateToEffect(re) then
				c:SetCardTarget(tc)
			end
		end
end
function Auxiliary.PersistentTargetFilter(e,c)
	return e:GetHandler():IsHasCardTarget(c)
end

pcall(dofile,"init.lua")
