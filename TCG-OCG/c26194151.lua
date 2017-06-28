--ネクロイド・シンクロ
function c26194151.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26194151.target)
	e1:SetOperation(c26194151.activate)
	c:RegisterEffect(e1)
end
function c26194151.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c26194151.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp,c)
end
function c26194151.filter2(c,tp,sc)
	local rg=Duel.GetMatchingGroup(c26194151.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if not c:IsType(TYPE_TUNER) or not c:IsAbleToRemove()
		or not rg:IsExists(c26194151.filterchk,1,nil,rg,Group.CreateGroup(),tp,c,sc) then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c26194151.filter3(c)
	if c:GetLevel()<=0 or c:IsType(TYPE_TUNER) or not c:IsAbleToRemove() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c26194151.filterchk(c,g,sg,tp,tuner,sc)
	sg:AddCard(c)
	sg:AddCard(tuner)
	local res=Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0 
		and sg:CheckWithSumEqual(Card.GetLevel,sc:GetLevel(),sg:GetCount(),sg:GetCount())
	sg:RemoveCard(tuner)	
	if sg:GetCount()<2 and not res then
		res=g:IsExists(c26194151.filterchk,1,sg,g,sg,tp,tuner,sc)
	end
	sg:RemoveCard(c)
	return res
end
function c26194151.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26194151.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26194151.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c26194151.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g1:GetFirst()
	if sc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c26194151.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp,sc)
		local tuner=g2:GetFirst()
		local rg=Duel.GetMatchingGroup(c26194151.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tuner)
		local sg=Group.CreateGroup()
		while sg:GetCount()<2 do
			local tg=rg:Filter(c26194151.filterchk,sg,rg,sg,tp,tuner,sc)
			if tg:GetCount()<=0 then break end
			sg:AddCard(tuner)
			local cancel=Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0 
				and sg:CheckWithSumEqual(Card.GetLevel,sc:GetLevel(),sg:GetCount(),sg:GetCount())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tc=Group.SelectUnselect(tg,sg,tp,cancel,cancel)
			sg:RemoveCard(tuner)
			if tc~-tuner then
				if sg:IsContains(tc) then
					sg:RemoveCard(tc)
				else
					sg:AddCard(tc)
				end
			end
		end
		sg:AddCard(tuner)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2,true)
		sc:CompleteProcedure()
		Duel.SpecialSummonComplete()
	end
end
