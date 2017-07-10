--Champion's Pulse
function c511002637.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511002637.condition)
	e1:SetTarget(c511002637.target)
	e1:SetOperation(c511002637.activate)
	c:RegisterEffect(e1)
	if not c511002637.global_check then
		c511002637.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002637.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002637.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002637.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
		and Duel.IsExistingMatchingCard(Card.IsChampion,tp,LOCATION_GRAVE,0,2,nil)
end
function c511002637.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
end
function c511002637.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(1-tp,1000,REASON_EFFECT)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
