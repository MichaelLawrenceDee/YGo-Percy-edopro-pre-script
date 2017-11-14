--Tuner's Mind
function c511001443.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c511001443.condition)
	e1:SetTarget(c511001443.target)
	e1:SetOperation(c511001443.activate)
	c:RegisterEffect(e1)
end
function c511001443.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsType(TYPE_SYNCHRO)
end
function c511001443.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	if chk==0 then return at and at:IsAbleToExtra() end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,at,1,0,0)
end
function c511001443.mgfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:GetReason()&0x80008==0x80008 and c:GetReasonCard()==sync
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001443.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local sumtype=tc:GetSummonType()
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 and sumtype==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 
		and mg:GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE) and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or mg:GetCount()==1) 
		and mg:FilterCount(aux.NecroValleyFilter(c511001443.mgfilter),nil,e,tp,tc)==mg:GetCount() and Duel.SelectYesNo(tp,aux.Stringid(32441317,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
		local g=mg:Filter(Card.IsType,nil,TYPE_TUNER)
		local atg=g:GetFirst()
		if g:GetCount()>1 then
			atg=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.ChangeAttackTarget(atg)
	end
end
