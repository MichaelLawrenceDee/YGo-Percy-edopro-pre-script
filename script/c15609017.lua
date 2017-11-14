--ヒドゥン・ショット
function c15609017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c15609017.cost)
	e1:SetTarget(c15609017.target)
	e1:SetOperation(c15609017.activate)
	c:RegisterEffect(e1)
end
function c15609017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c15609017.costfilter(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c15609017.rescon(sg,e,tp,mg)
	local ct=sg:GetCount()
	sg:AddCard(e:GetHandler())
	local res=Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,sg)
	sg:RemoveCard(e:GetHandler())
	return res
end
function c15609017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c15609017.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return aux.SelectUnselectGroup(rg,e,tp,nil,2,c15609017.rescon,0)
		else return false end
	end
	e:SetLabel(0)
	local rsg=aux.SelectUnselectGroup(rg,e,tp,nil,2,c15609017.rescon,1,tp,HINTMSG_REMOVE,c15609017.rescon)
	local ct=Duel.Remove(rsg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c15609017.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
