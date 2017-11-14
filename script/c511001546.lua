--Beast-borg Medal of Honor
function c511001546.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c511001546.condition)
	e1:SetTarget(c511001546.target)
	e1:SetOperation(c511001546.activate)
	c:RegisterEffect(e1)
end
function c511001546.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x50b) and tc:IsType(TYPE_FUSION)
end
function c511001546.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	if chk==0 then return at and at:IsCanBeEffectTarget(e) and at:IsDestructable() end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,at,1,0,0)
end
function c511001546.mgfilter(c,e,tp,fusc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:GetReason()&0x40008==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001546.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local sumable=true
	local sumtype=tc:GetSummonType()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if Duel.Destroy(tc,REASON_EFFECT)>0 and sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION and mg:GetCount()>0
		and mg:GetCount()<=ft and mg:FilterCount(aux.NecroValleyFilter(c511001546.mgfilter),nil,e,tp,tc)==mg:GetCount() then
		Duel.BreakEffect()
		if Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.BreakEffect()
			local sum=mg:GetSum(Card.GetAttack)
			Duel.Damage(1-tp,sum,REASON_EFFECT,true)
			Duel.Damage(tp,sum,REASON_EFFECT,true)
			Duel.RDComplete()
		end
	end
end
