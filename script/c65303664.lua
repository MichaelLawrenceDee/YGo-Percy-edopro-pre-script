--森の狩人イエロー・バブーン
function c65303664.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65303664,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c65303664.condition)
	e1:SetCost(c65303664.cost)
	e1:SetTarget(c65303664.target)
	e1:SetOperation(c65303664.operation)
	c:RegisterEffect(e1)
end
function c65303664.cfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsReason(REASON_BATTLE)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
		and bit.band(c:GetPreviousRaceOnField(),RACE_BEAST)~=0
end
function c65303664.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65303664.cfilter,1,nil,tp)
end
function c65303664.rfiletr(c)
	return c:IsRace(RACE_BEAST) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c65303664.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(c65303664.rfiletr,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and rg:GetCount()>1 
		and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0) end
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65303664.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65303664.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
