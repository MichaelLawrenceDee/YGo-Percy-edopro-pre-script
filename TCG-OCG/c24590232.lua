--王魂調和
function c24590232.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c24590232.condition)
	e1:SetOperation(c24590232.activate)
	c:RegisterEffect(e1)
end
function c24590232.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c24590232.filter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()<9 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c24590232.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp,c)
end
function c24590232.filter2(c,tp,sc)
	local rg=Duel.GetMatchingGroup(c24590232.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if not c:IsType(TYPE_TUNER) or not c:IsAbleToRemove()
		or not rg:IsExists(c24590232.filterchk,1,nil,rg,Group.CreateGroup(),tp,c,sc) then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c24590232.filter3(c)
	if c:GetLevel()<=0 or c:IsType(TYPE_TUNER) or not c:IsAbleToRemove() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c24590232.filterchk(c,g,sg,tp,tuner,sc)
	sg:AddCard(c)
	sg:AddCard(tuner)
	local res=Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0 
		and sg:CheckWithSumEqual(Card.GetLevel,sc:GetLevel(),sg:GetCount(),sg:GetCount())
	sg:RemoveCard(tuner)
	if not res then
		res=g:IsExists(c24590232.filterchk,1,sg,g,sg,tp,tuner,sc)
	end
	sg:RemoveCard(c)
	return res
end
function c24590232.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c24590232.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(24590232,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c24590232.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local sc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c24590232.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp,sc)
		local tuner=g2:GetFirst()
		local rg=Duel.GetMatchingGroup(c24590232.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tuner)
		local tc
		::start::
			local tg=rg:Filter(c24590232.filterchk,sg,rg,sg,tp,tuner,sc)
			if tg:GetCount()<=0 then goto jump end
			sg:AddCard(tuner)
			local cancel=Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0 
				and sg:CheckWithSumEqual(Card.GetLevel,sc:GetLevel(),sg:GetCount(),sg:GetCount())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			tc=Group.SelectUnselect(tg,sg,tp,cancel,cancel)
			if not tc then goto jump end
			sg:RemoveCard(tuner)
			if tc~-tuner then
				if sg:IsContains(tc) then
					sg:RemoveCard(tc)
				else
					sg:AddCard(tc)
				end
			end
			goto start
		::jump::
		sg:AddCard(tuner)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
