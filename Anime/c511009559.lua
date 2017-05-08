--Rank-Up-Magic Magical Force
function c511009559.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c511009559.sptg)
	e1:SetOperation(c511009559.spop)
	c:RegisterEffect(e1)
end
function c511009559.filter(c,e,tp,tid)
	local rk=c:GetRank()
	return rk>0 and c:GetTurnID()==tid and bit.band(c:GetReason(),REASON_BATTLE)~=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c511009559.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk,c)
end
function c511009559.spfilter(c,e,tp,rk,mc)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return c:GetRank()==rk+1 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and c:IsRace(RACE_SPELLCASTER) and mc:IsCanBeXyzMaterial(c)
end
function c511009559.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c511009559.filter(chkc,e,tp,tid) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and Duel.IsExistingTarget(c511009559.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511009559.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511009559.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c511009559.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank(),tc)
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.BreakEffect()
			Duel.Overlay(tc2,tc)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc2:SetMaterial(Group.FromCards(tc))
			tc2:CompleteProcedure()
			if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
				c:CancelToGrave()
				Duel.Overlay(tc2,Group.FromCards(c))
			end
		end
	end
end
