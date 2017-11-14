--DDD覇龍王ペンドラゴン
function c56619314.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56619314,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c56619314.spcost)
	e1:SetTarget(c56619314.sptg)
	e1:SetOperation(c56619314.spop)
	c:RegisterEffect(e1)
	--atk up/destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56619314,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c56619314.cost)
	e2:SetOperation(c56619314.operation)
	c:RegisterEffect(e2)
end
function c56619314.spfilter(c,rac,tp)
	return c:IsRace(rac) and c:IsControler(tp)
end
function c56619314.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c56619314.chk,1,nil,sg)
end
function c56619314.chk(c,sg)
	return c:IsRace(RACE_DRAGON) and sg:IsExists(Card.IsRace,1,c,RACE_FIEND)
end
function c56619314.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp,true)
	local g1=rg:Filter(c56619314.spfilter,nil,RACE_DRAGON,tp)
	local g2=rg:Filter(c56619314.spfilter,e:GetHandler(),RACE_FIEND,tp)
	local g=g1:Clone()
	g:Merge(g2)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g1:GetCount()>0 and g2:GetCount()>0 and g:GetCount()>1 
		and aux.SelectUnselectGroup(g,e,tp,2,2,c56619314.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c56619314.rescon,1,tp,HINTMSG_RELEASE)
	Duel.Release(sg,REASON_COST)
end
function c56619314.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c56619314.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c56619314.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c56619314.filter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable(e)
end
function c56619314.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(c56619314.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(56619314,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
