--ＢＦ－天狗風のヒレン
--fixed by MLD
function c511247014.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511247014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,511247014+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c511247014.spcon1)
	e1:SetTarget(c511247014.sptg)
	e1:SetOperation(c511247014.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c511247014.spcon2)
	c:RegisterEffect(e2)
end
function c511247014.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (ev>=2000 or (Duel.GetAttackTarget()==nil and e:GetHandler():GetFlagEffect(511247014)==0 
		and e:GetHandler():RegisterFlagEffect(511247014,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)))
end
function c511247014.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil and e:GetHandler():GetFlagEffect(511247014)==0
end
function c511247014.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsSetCard(0x33) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511247014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c511247014.filter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	e:GetHandler():RegisterFlagEffect(511247014,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_GRAVE)
end
function c511247014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 
		or not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511247014.filter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
