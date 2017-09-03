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
	if not c:IsSetCard(0x2016) or not c:IsType(TYPE_MONSTER) or not c:IsAbleToRemoveAsCost() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c15609017.filter(c,g,sg,card)
	sg:AddCard(c)
	local res
	if sg:GetCount()==1 then
		sg:AddCard(card)
		local des=Duel.IsExistingTarget(aux.TRUE,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,sg)
		sg:RemoveCard(card)
		res=des or g:IsExists(c15609017.filter,1,sg,g,sg,card)
	elseif sg:GetCount()==2 then
		sg:AddCard(card)
		res=Duel.IsExistingTarget(aux.TRUE,0,LOCATION_ONFIELD,LOCATION_ONFIELD,2,sg)
		sg:RemoveCard(card)
	else
		res=false
	end
	sg:RemoveCard(c)
	return res
end
function c15609017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c15609017.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return rg:IsExists(c15609017.filter,1,nil,rg,Group.CreateGroup(),c)
		else return false end
	end
	e:SetLabel(0)
	local rsg=Group.CreateGroup()
	local tc
	::start::
		rsg:AddCard(c)
		local cancel=rsg:GetCount()>0 
			and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,rsg:GetCount(),rsg)
		rsg:RemoveCard(c)
		local g=rg:Filter(c15609017.filter,rsg,rg,rsg,c)
		if g:GetCount()<=0 then goto jump end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=Group.SelectUnselect(g,rsg,tp,cancel,cancel)
		if not tc then goto jump end
		if rsg:IsContains(tc) then
			rsg:RemoveCard(tc)
		else
			rsg:AddCard(tc)
		end
		goto start
	::jump::
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
