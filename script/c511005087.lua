--Magic Rebounder
--マジック・リバウンダー
--	By Shad3
--fixed by MLD
function c511005087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511005087.condition)
	e1:SetTarget(c511005087.target)
	e1:SetOperation(c511005087.activate)
	c:RegisterEffect(e1)
end
function c511005087.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	return g:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetBattleDamage(tp)>0
end
function c511005087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget()):Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511005087.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget()):Filter(function(c) return c:IsControler(1-tp) and c:IsRelateToBattle() end,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
