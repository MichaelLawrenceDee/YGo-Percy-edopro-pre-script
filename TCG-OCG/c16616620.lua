--コンタクト
function c16616620.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c16616620.target)
	e1:SetOperation(c16616620.activate)
	c:RegisterEffect(e1)
end
function c16616620.filter1(c,e,tp)
	local class=_G["c"..c:GetOriginalCode()]
	if class==nil or class.listed_names==nil then return false end
	return c:IsSetCard(0x1e) and Duel.IsExistingMatchingCard(c16616620.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,class.listed_names,e,tp)
end
function c16616620.filter2(c,tcode,e,tp)
	return c:IsCode(table.unpack(tcode)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c16616620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c16616620.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c16616620.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x1e)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local class=_G["c"..tc:GetOriginalCode()]
		if not (class==nil or class.listed_names==nil) then
			local tg=Duel.GetMatchingGroup(c16616620.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,class.listed_names,e,tp)
			sg:Merge(tg)
		end
	end
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
	end
end
