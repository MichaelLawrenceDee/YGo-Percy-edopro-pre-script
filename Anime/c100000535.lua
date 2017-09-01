--Ragnarok
--Fixed by Edo9300
function c100000535.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000535,4))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000535.target)
	e1:SetOperation(c100000535.operation)
	c:RegisterEffect(e1)
end
c100000535.listed_names={46986414,92377303,46986414,,38033121,30208479}
function c100000535.cfilter(c)
	return c:IsFaceup() and c:IsCode(92377303,46986414,,38033121,30208479)
end
function c100000535.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c100000535.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) 
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c100000535.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c100000535.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg
	if Duel.IsPlayerAffectedByEffect(tp,69832741) then
		sg=Duel.GetMatchingGroup(Card.IsType,tp,0x03,0,nil,TYPE_MONSTER)
	else
		sg=Duel.GetMatchingGroup(Card.IsType,tp,0x13,0,nil,TYPE_MONSTER)
	end
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		if dg:GetCount()>0 then
			Duel.SendtoGrave(dg,REASON_DESTROY+REASON_EFFECT)
		end
	end
end
