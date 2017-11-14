--Royal Straight
function c511000088.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000088.cost)
	e1:SetTarget(c511000088.target)
	e1:SetOperation(c511000088.activate)
	c:RegisterEffect(e1)
end
function c511000088.filter(c,e,tp)
	return c:IsCode(511000089) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c511000088.cfilter(c,code)
	return c:IsCode(code) and c:IsPosition(POS_FACEUP_ATTACK)
end
function c511000088.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c511000088.chk,1,nil,sg,Group.CreateGroup(),25652259,64788463,90876561)
end
function c511000088.chk(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c511000088.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function c511000088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local rg=Duel.GetReleaseGroup(tp)
	local g1=rg:Filter(c511000088.cfilter,nil,25652259)
	local g2=rg:Filter(c511000088.cfilter,nil,64788463)
	local g3=rg:Filter(c511000088.cfilter,nil,90876561)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 
		and aux.SelectUnselectGroup(g,e,tp,3,3,c511000088.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,c511000088.rescon,1,tp,HINTMSG_RELEASE)
	Duel.Release(sg,REASON_COST)
end
function c511000088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c511000088.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c511000088.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c511000088.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
