--Master Spirit Tech Force - Pendulum Ruler
--fixed by Larry126
function c511009372.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	aux.AddFusionProcMix(c,true,true,511009366,function(c) return c:IsSpirit(true) end)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c511009372.distg)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c511009372.atlimit2)
	c:RegisterEffect(e2)
	--cannot be destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(25793414,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c511009372.eftg)
	e4:SetOperation(c511009372.efop)
	c:RegisterEffect(e4)
	--Set in P.Zone
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c511009372.pztg)
	e5:SetOperation(c511009372.pzop)	
	c:RegisterEffect(e5)
	--to extra
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTarget(c511009372.tetg)
	e6:SetOperation(c511009372.teop)
	c:RegisterEffect(e6)
	if not c511009372.global_check then
		c511009372.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAINING)
		ge:SetOperation(c511009372.checkop)
		Duel.RegisterEffect(ge,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511009372.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c511009372.material_setcode=0x54e
function c511009372.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsType(TYPE_MONSTER) then
			tc:RegisterFlagEffect(511009372,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=eg:GetNext()
	end
end
function c511009372.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511009372.atlimit2(e,c)
	return (not c:IsType(TYPE_PENDULUM) or c:IsLevelBelow(e:GetHandler():GetLevel())) and not c:IsImmuneToEffect(e)
end
function c511009372.distg(e,c)
	return (not c:IsType(TYPE_PENDULUM) or c:IsLevelBelow(e:GetHandler():GetLevel())) and c:IsType(TYPE_EFFECT)
end
function c511009372.effilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_HAND)
		and c:IsSetCard(0x154e) and c:GetFlagEffect(511009372)==0 and c:IsReleasableByEffect()
end
function c511009372.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511009372.effilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009372.effilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c511009372.effilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c511009372.efop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0 then
		Duel.MajesticCopy(c,tc)
		Duel.MajesticCopy(c,tc)
		e:GetHandler():RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		if c:GetFlagEffect(511009372)==0 then
			--double
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCountLimit(1)
			e1:SetTargetRange(1,1)
			e1:SetValue(c511009372.damval)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			c:RegisterFlagEffect(511009372,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c511009372.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_EFFECT)>0 and re:GetHandler()==c then return val*2 else return val end
end
function c511009372.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_PZONE,0,nil)<2 end
end
function c511009372.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c511009372.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not e:GetHandler():IsForbidden() end
end
function c511009372.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
