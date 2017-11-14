--Shark Splash
function c511002149.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c511002149.condition)
	e1:SetTarget(c511002149.target)
	e1:SetOperation(c511002149.activate)
	c:RegisterEffect(e1)
	if not c511002149.global_check then
		c511002149.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002149.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002149.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002149.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsShark() and c:IsType(TYPE_MONSTER) 
		and c:IsControler(tp) and c:GetPreviousControler()==tp
end
function c511002149.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511002149.cfilter,nil,tp)
	return g:GetCount()==1
end
function c511002149.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:Filter(c511002149.cfilter,nil,tp):GetFirst()
	if chk==0 then return tc:IsCanBeEffectTarget(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack()-1000)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c511002149.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		local atk=tc:GetAttack()
		if atk<=0 then return end
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
