--死霊の巣
function c6733059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c6733059.target)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6733059,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetCost(c6733059.descost)
	e2:SetOperation(c6733059.desop)
	c:RegisterEffect(e2)
end
function c6733059.cfilter(c)
	if not c:IsType(TYPE_MONSTER) or not c:IsAbleToRemoveAsCost() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c6733059.filter(c,g,sg)
	sg:AddCard(c)
	local res=Duel.IsExistingMatchingCard(c6733059.tfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,sg,sg:GetCount())	
		or g:IsExists(c6733059.filter,1,sg,g,sg)
	sg:RemoveCard(c)
	return res
end
function c6733059.tfilter(c,ct)
	return c:IsFaceup() and c:GetLevel()==ct
end
function c6733059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c6733059.descost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(6733059,0)) then
		c6733059.descost(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(c6733059.desop)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c6733059.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c6733059.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return cg:IsExists(c6733059.filter,1,nil,cg,Group.CreateGroup()) end
	local rg=Group.CreateGroup()
	::start::
		local cancel=rg:GetCount()>0 and Duel.IsExistingMatchingCard(c6733059.tfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,sg,sg:GetCount())
		local g=cg:Filter(c6733059.filter,rg,cg,rg)
		if g:GetCount()<=0 then goto jump end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Group.SelectUnselect(g,rg,tp,cancel,cancel)
		if not tc then goto jump end
		if rg:IsContains(tc) then
			rg:RemoveCard(tc)
		else
			rg:AddCard(tc)
		end
		goto start
	::jump::
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetTargetParam(rg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c6733059.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if lv==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c6733059.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lv)
	Duel.Destroy(g,REASON_EFFECT)
end
