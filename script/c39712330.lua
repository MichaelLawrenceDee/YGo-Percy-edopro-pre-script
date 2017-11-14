--決戦の火蓋
function c39712330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c39712330.target)
	c:RegisterEffect(e1)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39712330,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c39712330.con)
	e2:SetCost(c39712330.cost)
	e2:SetTarget(c39712330.tg)
	e2:SetOperation(c39712330.op)
	c:RegisterEffect(e2)
end
function c39712330.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c)
end
function c39712330.filter(c)
	return c:IsType(TYPE_NORMAL) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function c39712330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c39712330.con(e,tp,eg,ep,ev,re,r,rp) and c39712330.cost(e,tp,eg,ep,ev,re,r,rp,0) 
		and Duel.GetMatchingGroupCount(c39712330.filter,tp,LOCATION_HAND,0,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(39712330,1)) then
		c39712330.cost(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c39712330.op)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	else
		e:SetOperation(nil)
	end
end
function c39712330.con(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c39712330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39712330.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c39712330.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c39712330.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not e:GetHandler():IsStatus(STATUS_CHAINING) then
			local ct=Duel.GetMatchingGroupCount(c39712330.filter,tp,LOCATION_HAND,0,nil)
			e:SetLabel(ct)
			return ct>0
		else return e:GetLabel()>0 end
	end
	e:SetLabel(e:GetLabel()-1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c39712330.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c39712330.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
