--Underworld Resonance - Synchro Fusion
function c511002620.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002620.target)
	e1:SetOperation(c511002620.activate)
	c:RegisterEffect(e1)
end
function c511002620.chk(e,tp)
	local chkf=tp
	local fusmat=Duel.GetFusionMaterial(tp):Filter(function(c)return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) end,nil,tp)
	for i=0,6 do
		for j=0,6 do
			local c1=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
			local c2=Duel.GetFieldCard(tp,LOCATION_MZONE,j)
			local g=Group.FromCards(c1,c2)
			if c1 and c2 and fusmat:IsContains(c1) and fusmat:IsContains(c2) then
				if Duel.IsExistingMatchingCard(c511002620.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,nil,chkf) 
					and Duel.IsExistingMatchingCard(c511002620.synfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp) then
					return true
				end
			end
		end
	end
	for i=0,6 do
		for j=0,6 do
			for k=0,6 do
				local c1=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
				local c2=Duel.GetFieldCard(tp,LOCATION_MZONE,j)
				local c3=Duel.GetFieldCard(tp,LOCATION_MZONE,k)
				local g=Group.FromCards(c1,c2,c3)
				if c1 and c2 and c3 and fusmat:IsContains(c1) and fusmat:IsContains(c2)
					and fusmat:IsContains(c3) then
					if Duel.IsExistingMatchingCard(c511002620.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,nil,chkf) 
						and Duel.IsExistingMatchingCard(c511002620.synfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp) then
						return true
					end
				end
			end
		end
	end
	for i=0,6 do
		for j=0,6 do
			for k=0,6 do
				for l=0,6 do
					local c1=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
					local c2=Duel.GetFieldCard(tp,LOCATION_MZONE,j)
					local c3=Duel.GetFieldCard(tp,LOCATION_MZONE,k)
					local c4=Duel.GetFieldCard(tp,LOCATION_MZONE,l)
					local g=Group.FromCards(c1,c2,c3,c4)
					if c1 and c2 and c3 and c4 and fusmat:IsContains(c1) and fusmat:IsContains(c2)
						and fusmat:IsContains(c3) and fusmat:IsContains(c4) then
						if Duel.IsExistingMatchingCard(c511002620.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,nil,chkf) 
							and Duel.IsExistingMatchingCard(c511002620.synfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp) then
							return true
						end
					end
				end
			end
		end
	end
	for i=0,6 do
		for j=0,6 do
			for k=0,6 do
				for l=0,6 do
					for m=0,6 do
						local c1=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
						local c2=Duel.GetFieldCard(tp,LOCATION_MZONE,j)
						local c3=Duel.GetFieldCard(tp,LOCATION_MZONE,k)
						local c4=Duel.GetFieldCard(tp,LOCATION_MZONE,l)
						local c5=Duel.GetFieldCard(tp,LOCATION_MZONE,m)
						local g=Group.FromCards(c1,c2,c3,c4,c5)
						if c1 and c2 and c3 and c4 and c5 and fusmat:IsContains(c1) and fusmat:IsContains(c2)
							and fusmat:IsContains(c3) and fusmat:IsContains(c4) and fusmat:IsContains(c5) then
							if Duel.IsExistingMatchingCard(c511002620.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,nil,chkf) 
								and Duel.IsExistingMatchingCard(c511002620.synfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp) then
								return true
							end
						end
					end
				end
			end
		end
	end
	for i=0,6 do
		for j=0,6 do
			for k=0,6 do
				for l=0,6 do
					for m=0,6 do
						for n=0,6 do
							local c1=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
							local c2=Duel.GetFieldCard(tp,LOCATION_MZONE,j)
							local c3=Duel.GetFieldCard(tp,LOCATION_MZONE,k)
							local c4=Duel.GetFieldCard(tp,LOCATION_MZONE,l)
							local c5=Duel.GetFieldCard(tp,LOCATION_MZONE,m)
							local c6=Duel.GetFieldCard(tp,LOCATION_MZONE,n)
							local g=Group.FromCards(c1,c2,c3,c4,c5,c6)
							if c1 and c2 and c3 and c4 and c5 and c6 and fusmat:IsContains(c1) and fusmat:IsContains(c2)
								and fusmat:IsContains(c3) and fusmat:IsContains(c4) and fusmat:IsContains(c5)
								and fusmat:IsContains(c6) then
								if Duel.IsExistingMatchingCard(c511002620.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,nil,chkf) 
									and Duel.IsExistingMatchingCard(c511002620.synfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp) then
									return true
								end
							end
						end
					end
				end
			end
		end
	end
	local c1=Duel.GetFieldCard(tp,LOCATION_MZONE,0)
	local c2=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
	local c3=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	local c4=Duel.GetFieldCard(tp,LOCATION_MZONE,3)
	local c5=Duel.GetFieldCard(tp,LOCATION_MZONE,4)
	local c6=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
	local c7=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
	local g=Group.FromCards(c1,c2,c3,c4,c5,c6,c7)
	return c1 and c2 and c3 and c4 and c5 and c6 and c6 and fusmat:IsContains(c1) and fusmat:IsContains(c2)
		and fusmat:IsContains(c3) and fusmat:IsContains(c4) and fusmat:IsContains(c5)	and fusmat:IsContains(c6) and fusmat:IsContains(c6)
		and Duel.IsExistingMatchingCard(c511002620.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,nil,chkf) 
		and Duel.IsExistingMatchingCard(c511002620.synfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp)
end
function c511002620.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c511002620.filter2(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil)
end
function c511002620.synfilter(c,mg,tp)
	return c:IsSynchroSummonable(nil,mg) and mg:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),mg:GetCount(),mg:GetCount(),c) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>1
end
function c511002620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chk==0 then return (not ect or ect>=2) and c511002620.chk(e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and (not ect or ect>=2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c511002620.activate(e,tp,eg,ep,ev,re,r,rp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if not c511002620.chk(e,tp) or Duel.IsPlayerAffectedByEffect(tp,29724053) or (ect and ect<2) then return end
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c511002620.filter1,tp,LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c511002620.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	if sg1:GetCount()>0 then
		local sg=sg1:Clone()
		local tc2=nil
		local tc=nil
		local mat1=Group.CreateGroup()
		while not tc or not tc2 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tc=sg:Select(tp,1,1,nil):GetFirst()
			mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc2=Duel.SelectMatchingCard(tp,c511002620.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,mat1):GetFirst()
		end
		tc:SetMaterial(mat1)
		tc2:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_SYNCHRO)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummon(tc2,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
		tc2:CompleteProcedure()
	end
end
