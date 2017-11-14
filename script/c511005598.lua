--Gorgonic Temptaion
--scripted by GameMaster(GM)
--fixed by MLD
function c511005598.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511005598.target)
	c:RegisterEffect(e1)
	--choose atk target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c511005598.atkcon)
	e2:SetTarget(c511005598.atktg)
	e2:SetOperation(c511005598.atkop)
	c:RegisterEffect(e2)
	if not c511005598.global_check then
		c511005598.global_check=true
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetCountLimit(1)
		ge4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge4:SetOperation(c511005598.archchk)
		Duel.RegisterEffect(ge4,0)
	end
end
function c511005598.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511005598.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and c511005598.atkcon(e,tp,Group.FromCards(a),ep,ev,re,r,rp) 
		and c511005598.atktg(e,tp,Group.FromCards(a),ep,ev,re,r,rp,0) 
		and Duel.SelectYesNo(tp,aux.Stringid(61965407,1)) then
		e:SetOperation(c511005598.atkop)
		c511005598.atktg(e,tp,Group.FromCards(a),ep,ev,re,r,rp,1)
	else
		e:SetOperation(nil)
	end
end
function c511005598.filter(c)
	return c:IsFaceup() and c:IsGorgonic()
end
function c511005598.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp) and Duel.IsExistingMatchingCard(c511005598.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c511005598.atkfilter(c,a)
	return a:GetAttackableTarget():IsContains(c)
end
function c511005598.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then return e:GetHandler():GetFlagEffect(511005598)==0 
		and Duel.IsExistingMatchingCard(c511005598.atkfilter,tp,LOCATION_MZONE,0,1,Group.FromCards(a,Duel.GetAttackTarget()),a) end
	e:GetHandler():RegisterFlagEffect(511005598,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c511005598.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local a=Duel.GetAttacker()
	local g=Duel.SelectMatchingCard(tp,c511005598.atkfilter,tp,LOCATION_MZONE,0,1,1,Group.FromCards(a,Duel.GetAttackTarget()),a)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.ChangeAttackTarget(g:GetFirst())
	end
end
