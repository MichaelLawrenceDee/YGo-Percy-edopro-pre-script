--E・HERO ストーム・ネオス
function c511023007.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,89943723,17955766,54959865)
	aux.AddContactFusion(c,c511023007.contactfil,c511023007.contactop)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c511023007.splimit)
	c:RegisterEffect(e1)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511023007,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511023007.retcon1)
	e3:SetTarget(c511023007.rettg)
	e3:SetOperation(c511023007.retop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0)
	e4:SetCondition(c511023007.retcon2)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511023007,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c511023007.destg)
	e5:SetOperation(c511023007.desop)
	c:RegisterEffect(e5)
end
c511023007.material_setcode=0x8
function c511023007.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c511023007.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c511023007.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function c511023007.retcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(42015635)
end
function c511023007.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(42015635)
end
function c511023007.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c511023007.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+511023007,e,0,0,0,0)
	end
end
function c511023007.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c511023007.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511023007.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c511023007.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511023007.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511023007.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end