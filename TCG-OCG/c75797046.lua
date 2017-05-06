--フォトン・アレキサンドラ・クィーン
function c75797046.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6a),4,2)
	c:EnableReviveLimit()
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75797046,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c75797046.retcost)
	e1:SetTarget(c75797046.rettg)
	e1:SetOperation(c75797046.retop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(511002571)
	e2:SetLabelObject(e1)
	e2:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e2)
end
function c75797046.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75797046.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c75797046.hfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function c75797046.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local ct1=g:FilterCount(c75797046.hfilter,nil,tp)
	local ct2=g:FilterCount(c75797046.hfilter,nil,1-tp)
	Duel.Damage(tp,ct1*300,REASON_EFFECT,true)
	Duel.Damage(1-tp,ct2*300,REASON_EFFECT,true)
	Duel.RDComplete()
end
