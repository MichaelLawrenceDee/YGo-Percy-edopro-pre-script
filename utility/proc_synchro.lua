
function Auxiliary.NonTuner(f,a,b,c)
	return	function(target)
				return target:IsNotTuner() and (not f or f(target,a,b,c))
			end
end
--Synchro monster, m-n tuners + m-n monsters
--function Auxiliary.AddSynchroProcedure(c,f1,f2,ct)
function Auxiliary.AddSynchroProcedure(c,...)
	if c.synchro_type==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.synchro_type=1
		mt.synchro_parameters={...}
	end	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynCondition(...))
	e1:SetTarget(Auxiliary.SynTarget(...))
	e1:SetOperation(Auxiliary.SynOperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Auxiliary.SynchroCheckFilterChk(c,f1,f2,sub1,sub2)
	local te=c:GetCardEffect(EFFECT_SYNCHRO_CHECK)
	if not te then return false end
	local f=te:GetValue()
	local reset=false
	if f(te,c) then
		reset=true
	end
	local res=(c:IsType(TYPE_TUNER) and (not f1 or f1(c))) or not f2 or f2(c) or (sub1 and sub1(c)) or (sub2 and sub2(c))
	if reset then
		Duel.AssumeReset()
	end
	return res
end
function Auxiliary.TunerFilter(c,f1,sub1)
	return (c:IsType(TYPE_TUNER) and (not f1 or f1(c))) or (sub1 and sub1(c))
end
function Auxiliary.NonTunerFilter(c,f2,sub2)
	return not f2 or f2(c) or (sub2 and sub2(c))
end
--function Auxiliary.SynCondition(f1,f2,minc,maxc)
function Auxiliary.SynCondition(f1,min1,max1,f2,min2,max2,sub1,sub2,req1,reqct1,req2,reqct2,reqm)
	return	function(e,c,smat,mg)
				if c==nil then return true end
				local tp=c:GetControler()
				local pe={Duel.GetPlayerEffect(tp,EFFECT_MUST_BE_SMATERIAL)}
				local pg=Group.CreateGroup()
				local lv=c:GetLevel()
				if pe[1] then
					for i,eff in ipairs(pe) do
						pg:AddCard(eff:GetOwner())
					end
				end
				local g
				local mgchk
				if mg then
					g=mg:Filter(Card.IsCanBeSynchroMaterial,c,c)
					mgchk=true
				else
					g=Duel.GetMatchingGroup(function(mc) return mc:IsFaceup() and mc:IsCanBeSynchroMaterial(c) end,tp,LOCATION_MZONE,LOCATION_MZONE,c)
					mgchk=false
				end
				if g:IsExists(Auxiliary.SynchroCheckFilterChk,1,nil,f1,f2,sub1,sub2) then
					--if there is a monster with EFFECT_SYNCHRO_CHECK (Genomix Fighter/Mono Synchron)
					local g2=g:Clone()
					if not mgchk then
						local thg=g2:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
						local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
						local thc=thg:GetFirst()
						while thc do
							local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
							local val=te:GetValue()
							local ag=hg:Filter(function(mc) return val(te,mc,c) end,nil) --tuner
							g2:Merge(ag)
							thc=thg:GetNext()
						end
					end
					local res=(not smat or g2:IsContains(smat)) 
						and g2:IsExists(Auxiliary.SynchroCheckP31,1,nil,g2,Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup(),f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
					local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					local hc=hg:GetFirst()
					while hc do
						local effs={hc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
						for _,v in ipairs(effs) do
							v:Reset()
						end
						hc=hg:GetNext()
					end
					Duel.AssumeReset()
					return res
				else
					--no race change
					local tg
					local ntg
					if mgchk then
						tg=g:Filter(Auxiliary.TunerFilter,nil,f1,sub1)
						ntg=g:Filter(Auxiliary.NonTunerFilter,nil,f2,sub2)
					else
						tg=g:Filter(Auxiliary.TunerFilter,nil,f1,sub1)
						ntg=g:Filter(Auxiliary.NonTunerFilter,nil,f2,sub2)
						local thg=tg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
						thg:Merge(ntg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO))
						local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
						local thc=thg:GetFirst()
						while thc do
							local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
							local val=te:GetValue()
							local thag=hg:Filter(function(mc) return Auxiliary.TunerFilter(mc,f1,sub1) and val(te,mc,c) end,nil) --tuner
							local nthag=hg:Filter(function(mc) return Auxiliary.NonTunerFilter(mc,f2,sub2) and val(te,mc,c) end,nil) --non-tuner
							tg:Merge(thag)
							ntg:Merge(nthag)
							thc=thg:GetNext()
						end
					end
					local lv=c:GetLevel()
					local res=(not smat or tg:IsContains(smat) or ntg:IsContains(smat)) 
						and tg:IsExists(Auxiliary.SynchroCheckP41,1,nil,tg,ntg,Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup(),min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
					local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					local hc=hg:GetFirst()
					while hc do
						local effs={hc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
						for _,v in ipairs(effs) do
							v:Reset()
						end
						hc=hg:GetNext()
					end
					return res
					--[[local okg=false
					if g:IsExists(Card.IsHasEffect,1,nil,511000806) then okg=true end
					local okh=false
					if g:IsExists(Card.IsHasEffect,1,nil,EFFECT_HAND_SYNCHRO) then okh=true end
					if okg then
						local g2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_GRAVE,0,c)
						g:Merge(g2)
					end
					if okh then
						local g2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,c)
						g:Merge(g2)
					end]]
				end
				return false
			end
end
function Auxiliary.SynchroCheckP31(c,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(EFFECT_SYNCHRO_CHECK) then
		local teg={c:GetCardEffect(EFFECT_SYNCHRO_CHECK)}
		for i=1,#teg do
			local te=teg[i]
			local val=te:GetValue()
			local tg=g:Filter(function(mc) return val(te,mc) end,nil)
			rg=tg:Filter(function(mc) return not Auxiliary.TunerFilter(mc,f1,sub1) and not Auxiliary.NonTunerFilter(mc,f2,sub2) end,nil)
		end
	end
	--c has the synchro limit
	if c:IsHasEffect(73941492+TYPE_SYNCHRO) then
		local eff={c:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for i,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then return false end
			local sg1=g:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			rg:Merge(sg1)
		end
	end
	--A card in the selected group has the synchro lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_SYNCHRO)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			local eff={tc:GetCardEffect(73941492+TYPE_SYNCHRO)}
			for i,f in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then return false end
			end
			tc=g2:GetNext()
		end	
	end
	if not mgchk then
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for i=1,#teg do
				local te=teg[i]
				local tgchk=te:GetTarget()
				local res,trg,ntrg2=tgchk(te,c,sg,g,g,tsg,ntsg)
				--if not res then return false end
				if res then
					rg:Merge(trg)
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
		g2=sg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		if g2:GetCount()>0 then
			local tc=g2:GetFirst()
			while tc do
				local eff={tc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
				local hanchk=false
				for i,te in ipairs(eff) do
					--if not te:GetTarget()(te,nil,sg,g,g,tsg,ntsg) then return false end
					if te:GetTarget()(te,nil,sg,g,g,tsg,ntsg) then
						hanchk=true
						break
					end
				end
				if not hanchk then return false end
				tc=g2:GetNext()
			end	
		end
	end
	g:Sub(rg)
	tsg:AddCard(c)
	sg:AddCard(c)
	if tsg:GetCount()<min1 then
		res=g:IsExists(Auxiliary.SynchroCheckP31,1,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	elseif tsg:GetCount()<max1 then
		res=g:IsExists(Auxiliary.SynchroCheckP31,1,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk) 
			or (tsg:IsExists(Auxiliary.TunerFilter,tsg:GetCount(),nil,f1,sub1) and (not req1 or tsg:IsExists(req1,reqct1,nil,tp)) 
				and g:IsExists(Auxiliary.SynchroCheckP32,1,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk))
	else
		res=tsg:IsExists(Auxiliary.TunerFilter,tsg:GetCount(),nil,f1,sub1) and (not req1 or tsg:IsExists(req1,reqct1,nil,tp)) 
			and g:IsExists(Auxiliary.SynchroCheckP32,1,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	end
	g:Merge(rg)
	tsg:RemoveCard(c)
	sg:RemoveCard(c)
	if not sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_CHECK) then
		Duel.AssumeReset()
	end
	return res
end
function Auxiliary.SynchroCheckP32(c,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(EFFECT_SYNCHRO_CHECK) then
		local teg={c:GetCardEffect(EFFECT_SYNCHRO_CHECK)}
		for i=1,#teg do
			local te=teg[i]
			local val=te:GetValue()
			local tg=g:Filter(function(mc) return val(te,mc) end,nil)
			rg=tg:Filter(function(mc) return not Auxiliary.NonTunerFilter(mc,f2,sub2) end,nil)
		end
	end
	--c has the synchro limit
	if c:IsHasEffect(73941492+TYPE_SYNCHRO) then
		local eff={c:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for i,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then return false end
			local sg2=ntg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			rg:Merge(sg2)
		end
	end
	--A card in the selected group has the synchro lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_SYNCHRO)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			local eff={tc:GetCardEffect(73941492+TYPE_SYNCHRO)}
			for i,f in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then return false end
			end
			tc=g2:GetNext()
		end	
	end
	if not mgchk then
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for i=1,#teg do
				local te=teg[i]
				local tgchk=te:GetTarget()
				local res,trg2,ntrg2=tgchk(te,c,sg,Group.CreateGroup(),g,tsg,ntsg)
				--if not res then return false end
				if res then
					rg:Merge(ntrg2)
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
		g2=sg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		if g2:GetCount()>0 then
			local tc=g2:GetFirst()
			while tc do
				local eff={tc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
				local hanchk=false
				for i,te in ipairs(eff) do
					--if not te:GetTarget()(te,nil,sg,Group.CreateGroup(),g,tsg,ntsg) then return false end
					if te:GetTarget()(te,nil,sg,Group.CreateGroup(),g,tsg,ntsg) then
						hanchk=true
						break
					end
				end
				if not hanchk then return false end
				tc=g2:GetNext()
			end	
		end
	end
	g:Sub(rg)
	ntsg:AddCard(c)
	sg:AddCard(c)
	if ntsg:GetCount()<min2 then
		res=g:IsExists(Auxiliary.SynchroCheckP32,1,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	elseif ntsg:GetCount()<max2 then
		res=g:IsExists(Auxiliary.SynchroCheckP32,1,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk) 
			or ((not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
				and ntsg:IsExists(Auxiliary.NonTunerFilter,ntsg:GetCount(),nil,f2,sub2) and (not smat or sg:IsContains(smat)) 
				and (pg:GetCount()<=0 or pg:IsExists(function(mc) return sg:IsContains(mc) end,pg:GetCount(),nil)) 
				and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp))
	else
		res=(not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
			and ntsg:IsExists(Auxiliary.NonTunerFilter,ntsg:GetCount(),nil,f2,sub2)
			and (not smat or sg:IsContains(smat))  and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp)
	end
	g:Merge(rg)
	ntsg:RemoveCard(c)
	sg:RemoveCard(c)
	if not sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_CHECK) then
		Duel.AssumeReset()
	end
	return res
end
function Auxiliary.SynchroCheckP41(c,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	local res
	local trg=Group.CreateGroup()
	local ntrg=Group.CreateGroup()
	--c has the synchro limit
	if c:IsHasEffect(73941492+TYPE_SYNCHRO) then
		local eff={c:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for i,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then return false end
			local sg1=tg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			local sg2=ntg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			trg:Merge(sg1)
			ntrg:Merge(sg2)
		end
	end
	--A card in the selected group has the synchro lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_SYNCHRO)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			local eff={tc:GetCardEffect(73941492+TYPE_SYNCHRO)}
			for i,f in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then return false end
			end
			tc=g2:GetNext()
		end	
	end
	if not mgchk then
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for i,te in ipairs(teg) do
				local tgchk=te:GetTarget()
				local res,trg2,ntrg2=tgchk(te,c,sg,tg,ntg,tsg,ntsg)
				--if not res then return false end
				if res then
					trg:Merge(trg2)
					ntrg:Merge(ntrg2)
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
		g2=sg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		if g2:GetCount()>0 then
			local tc=g2:GetFirst()
			while tc do
				local eff={tc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
				local hanchk=false
				for i,te in ipairs(eff) do
					--if not te:GetTarget()(te,nil,sg,tg,ntg,tsg,ntsg) then return false end
					if te:GetTarget()(te,nil,sg,tg,ntg,tsg,ntsg) then
						hanchk=true
						break
					end
				end
				if not hanchk then return false end
				tc=g2:GetNext()
			end	
		end
	end
	tg:Sub(trg)
	ntg:Sub(ntrg)
	tsg:AddCard(c)
	sg:AddCard(c)
	if tsg:GetCount()<min1 then
		res=tg:IsExists(Auxiliary.SynchroCheckP41,1,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	elseif tsg:GetCount()<max1 then
		res=tg:IsExists(Auxiliary.SynchroCheckP41,1,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk) 
			or ((not req1 or tsg:IsExists(req1,reqct1,nil,tp)) and ntg:IsExists(Auxiliary.SynchroCheckP42,1,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk))
	else
		res=(not req1 or tsg:IsExists(req1,reqct1,nil,tp)) 
			and ntg:IsExists(Auxiliary.SynchroCheckP42,1,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	end
	tg:Merge(trg)
	ntg:Merge(ntrg)
	tsg:RemoveCard(c)
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SynchroCheckP42(c,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	local res
	local ntrg=Group.CreateGroup()
	--c has the synchro limit
	if c:IsHasEffect(73941492+TYPE_SYNCHRO) then
		local eff={c:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for i,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then return false end
			local sg2=ntg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			ntrg:Merge(sg2)
		end
	end
	--A card in the selected group has the synchro lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_SYNCHRO)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			local eff={tc:GetCardEffect(73941492+TYPE_SYNCHRO)}
			for i,f in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then return false end
			end
			tc=g2:GetNext()
		end	
	end
	if not mgchk then
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for i=1,#teg do
				local te=teg[i]
				local tgchk=te:GetTarget()
				local res,trg2,ntrg2=tgchk(te,c,sg,Group.CreateGroup(),ntg,tsg,ntsg)
				--if not res then return false end
				if res then
					ntrg:Merge(ntrg2)
					hanchk=true
					break
				end
				if not hanchk then return false end
			end
		end
		g2=sg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		if g2:GetCount()>0 then
			local tc=g2:GetFirst()
			local hanchk=false
			while tc do
				local eff={tc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
				for i,te in ipairs(eff) do
					--if not te:GetTarget()(te,nil,sg,Group.CreateGroup(),ntg,tsg,ntsg) then return false end
					if te:GetTarget()(te,nil,sg,Group.CreateGroup(),ntg,tsg,ntsg) then
						hanchk=true
						break
					end
				end
				if not hanchk then return false end
				tc=g2:GetNext()
			end	
		end
	end
	ntg:Sub(ntrg)
	ntsg:AddCard(c)
	sg:AddCard(c)
	if ntsg:GetCount()<min2 then
		res=ntg:IsExists(Auxiliary.SynchroCheckP42,1,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk)
	elseif ntsg:GetCount()<max2 then
		res=ntg:IsExists(Auxiliary.SynchroCheckP42,1,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,smat,pg,mgchk) 
			or ((not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
				and (not smat or sg:IsContains(smat)) and (pg:GetCount()<=0 or pg:IsExists(function(mc) return sg:IsContains(mc) end,pg:GetCount(),nil)) 
				and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp))
	else
		res=(not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
			and (not smat or sg:IsContains(smat))  and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp)
	end
	ntg:Merge(ntrg)
	ntsg:RemoveCard(c)
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SynchroCheckLabel(c,label)
	return c:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:GetCardEffect(EFFECT_HAND_SYNCHRO):GetLabel()==label
end
function Auxiliary.SynchroCheckHand(c,sg)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
	for i,te in ipairs(teg) do
		if sg:IsExists(Auxiliary.SynchroCheckLabel,1,c,te:GetLabel()) then return false end
	end
	return true
end
function Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp)
	if sg:IsExists(Auxiliary.SynchroCheckHand,1,nil,sg) then return false end
	local lvchk=false
	if sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_MATERIAL_CUSTOM) then
		local g=sg:Filter(Card.IsHasEffect,nil,EFFECT_SYNCHRO_MATERIAL_CUSTOM)
		local tc=g:GetFirst()
		while tc do
			local teg={tc:GetCardEffect(EFFECT_SYNCHRO_MATERIAL_CUSTOM)}
			for i,te in ipairs(teg) do
				local op=te:GetOperation()
				local ok,tlvchk=op(te,tg,ntg,sg,lv,sc,tp)
				if not ok then return false end
				lvchk=lvchk or tlvchk
			end
			tc=g:GetNext()
		end
	end
	return (lvchk or sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,sg:GetCount(),sg:GetCount(),sc))
	and ((sc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0)
		or (not sc:IsLocation(LOCATION_EXTRA) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sg:IsExists(Auxiliary.FConditionCheckF,nil,tp))))
end
function Auxiliary.SynTarget(f1,min1,max1,f2,min2,max2,sub1,sub2,req1,reqct1,req2,reqct2,reqm)
--function Auxiliary.SynTarget(f1,f2,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg)
				local sg=Group.CreateGroup()
				local pe={Duel.GetPlayerEffect(tp,EFFECT_MUST_BE_SMATERIAL)}
				local pg=Group.CreateGroup()
				local lv=c:GetLevel()
				if pe[1] then
					for i,eff in ipairs(pe) do
						pg:AddCard(eff:GetOwner())
					end
				end
				local mgchk
				local g
				if mg then
					mgchk=true
					g=mg:Filter(Card.IsCanBeSynchroMaterial,c,c)
				else
					mgchk=false
					g=Duel.GetMatchingGroup(function(mc) return mc:IsFaceup() and mc:IsCanBeSynchroMaterial(c) end,tp,LOCATION_MZONE,LOCATION_MZONE,c)
				end
				local tg
				local ntg
				if mgchk then
					tg=g:Filter(Auxiliary.TunerFilter,nil,f1,sub1)
					ntg=g:Filter(Auxiliary.NonTunerFilter,nil,f2,sub2)
				else
					tg=g:Filter(Auxiliary.TunerFilter,nil,f1,sub1)
					ntg=g:Filter(Auxiliary.NonTunerFilter,nil,f2,sub2)
					local thg=tg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
					thg:Merge(ntg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO))
					local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
					local thc=thg:GetFirst()
					while thc do
						local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
						local val=te:GetValue()
						local thag=hg:Filter(function(mc) return Auxiliary.TunerFilter(mc,f1,sub1) and val(te,mc,c) end,nil) --tuner
						local nthag=hg:Filter(function(mc) return Auxiliary.NonTunerFilter(mc,f2,sub2) and val(te,mc,c) end,nil) --non-tuner
						tg:Merge(thag)
						ntg:Merge(nthag)
						thc=thg:GetNext()
					end
				end
				local lv=c:GetLevel()
				if g:IsExists(Auxiliary.SynchroCheckFilterChk,1,nil,f1,f2,sub1,sub2) then
					local tsg=Group.CreateGroup()
					local ntsg=Group.CreateGroup()
					local tune=true
					local g2=Group.CreateGroup()
					while ntsg:GetCount()<max2 do
						local cancel=false
						if tune then
							cancel=not mgchk and Duel.GetCurrentChain()<=0 and tsg:GetCount()==0
							local g3=ntg:Filter(Auxiliary.SynchroCheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
							g2=g:Filter(Auxiliary.SynchroCheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
							if g3:GetCount()>0 and tsg:GetCount()>=min1 and tsg:IsExists(Auxiliary.TunerFilter,tsg:GetCount(),nil,f1,sub1) and (not req1 or tsg:IsExists(req1,reqct1,nil,tp)) then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,cancel,cancel)
							if not tc then
								if tsg:GetCount()>=min1 and tsg:IsExists(Auxiliary.TunerFilter,tsg:GetCount(),nil,f1,sub1) and (not req1 or tsg:IsExists(req1,reqct1,nil,tp))
									and ntg:Filter(Auxiliary.SynchroCheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk):GetCount()>0 then tune=false
								else
									return false
								end
							end
							if not sg:IsContains(tc) then
								if g3:IsContains(tc) then
									ntsg:AddCard(tc)
									tune = false
								else
									tsg:AddCard(tc)
								end
								sg:AddCard(tc)
							else
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
							end
							if g:FilterCount(Auxiliary.SynchroCheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)==0 or tsg:GetCount()>=max2 then
								tune=false
							end
						else
							if (ntsg:GetCount()>=min2 and (not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
								and ntsg:IsExists(Auxiliary.NonTunerFilter,ntsg:GetCount(),nil,f2,sub2)
								and (not smat or sg:IsContains(smat)) and (pg:GetCount()<=0 or pg:IsExists(function(mc) return sg:IsContains(mc) end,pg:GetCount(),nil)) 
								and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,c,tp)) or (not mgchk and Duel.GetCurrentChain()<=0) then
									cancel=true
							end
							g2=g:Filter(Auxiliary.SynchroCheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
							if g2:GetCount()==0 then break end
							local g3=g:Filter(Auxiliary.SynchroCheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
							if g3:GetCount()>0 and ntsg:GetCount()==0 then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,cancel,cancel)
							if not tc then
								if ntsg:GetCount()>=min2 and (not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
									and (pg:GetCount()<=0 or pg:IsExists(function(mc) return sg:IsContains(mc) end,pg:GetCount(),nil))
									and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,c,tp) then break end
								return false
							end
							if not tsg:IsContains(tc) then
								if not sg:IsContains(tc) then
									ntsg:AddCard(tc)
									sg:AddCard(tc)
								else
									ntsg:RemoveCard(tc)
									sg:RemoveCard(tc)
								end
							elseif ntsg:GetCount()==0 then
								tune=true
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
							end
						end
					end
					Duel.AssumeReset()
				else
					local tsg=Group.CreateGroup()
					local ntsg=Group.CreateGroup()
					local tune=true
					local g2=Group.CreateGroup()
					while ntsg:GetCount()<max2 do
						cancel=false
						if tune then
							cancel=not mgchk and Duel.GetCurrentChain()<=0 and tsg:GetCount()==0
							local g3=ntg:Filter(Auxiliary.SynchroCheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
							g2=tg:Filter(Auxiliary.SynchroCheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
							if g3:GetCount()>0 and tsg:GetCount()>=min1 and (not req1 or tsg:IsExists(req1,reqct1,nil,tp)) then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,cancel,cancel)
							if not tc then
								if tsg:GetCount()>=min1 and (not req1 or tsg:IsExists(req1,reqct1,nil,tp))
									and ntg:Filter(Auxiliary.SynchroCheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk):GetCount()>0 then tune=false
								else
									return false
								end
							else
								if not sg:IsContains(tc) then
									if g3:IsContains(tc) then
										ntsg:AddCard(tc)
										tune = false
									else
										tsg:AddCard(tc)
									end
									sg:AddCard(tc)
								else
									tsg:RemoveCard(tc)
									sg:RemoveCard(tc)
								end
							end
							if tg:FilterCount(Auxiliary.SynchroCheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)==0 or tsg:GetCount()>=max1 then
								tune=false
							end
						else
							if ntsg:GetCount()>=min2 and (not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp))
								and (not smat or sg:IsContains(smat)) and (pg:GetCount()<=0 or pg:IsExists(function(mc) return sg:IsContains(mc) end,pg:GetCount(),nil))
								and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,c,tp) then cancel=true
							end
							g2=ntg:Filter(Auxiliary.SynchroCheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
							if g2:GetCount()==0 then break end
							local g3=tg:Filter(Auxiliary.SynchroCheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,smat,pg,mgchk)
							if g3:GetCount()>0 and ntsg:GetCount()==0 then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,cancel,cancel)
							if not tc then
								if ntsg:GetCount()>=min2 and (not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp))
									and (pg:GetCount()<=0 or pg:IsExists(function(mc) return sg:IsContains(mc) end,pg:GetCount(),nil))
									and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,c,tp) then break end
								return false
							end
							if not tsg:IsContains(tc) then
								if not sg:IsContains(tc) then
									ntsg:AddCard(tc)
									sg:AddCard(tc)
								else
									ntsg:RemoveCard(tc)
									sg:RemoveCard(tc)
								end
							elseif ntsg:GetCount()==0 then
								tune=true
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
							end
						end
					end
				end
				local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
				local hc=hg:GetFirst()
				while hc do
					local effs={hc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
 					for _,v in ipairs(effs) do
 						v:Reset()
 					end
					hc=hg:GetNext()
				end
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
Auxiliary.SynchroSend=0
function Auxiliary.SynOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	if Auxiliary.SynchroSend==1 then
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO+REASON_RETURN)
	elseif Auxiliary.SynchroSend==2 then
		Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	elseif Auxiliary.SynchroSend==3 then
		Duel.Remove(g,POS_FACEDOWN,REASON_MATERIAL+REASON_SYNCHRO)
	elseif Auxiliary.SynchroSend==4 then
		Duel.SendtoHand(g,nil,REASON_MATERIAL+REASON_SYNCHRO)
	elseif Auxiliary.SynchroSend==5 then
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
	elseif Auxiliary.SynchroSend==6 then
		Duel.Destroy(g,REASON_MATERIAL+REASON_SYNCHRO)
	else
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	end
	g:DeleteGroup()
end
