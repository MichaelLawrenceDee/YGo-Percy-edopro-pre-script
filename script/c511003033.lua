--ヨコシマウマ
function c511003033.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c511003033.reg)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97466438,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c511003033.ztg)
	e2:SetOperation(c511003033.zop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--disable zone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(97466438,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c511003033.zcon)
	e4:SetTarget(c511003033.ztg)
	e4:SetOperation(c511003033.zop)
	c:RegisterEffect(e4)
end
function c511003033.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(97466438,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c511003033.zcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(97466438)~=0
end
function c511003033.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		+Duel.GetLocationCount(tp,LOCATION_SZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 
		or not Duel.CheckLocation(tp,LOCATION_MZONE,5) or not Duel.CheckLocation(tp,LOCATION_MZONE,6) 
		or not Duel.CheckLocation(1-tp,LOCATION_MZONE,5) or not Duel.CheckLocation(1-tp,LOCATION_MZONE,6) end
	local dis=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0x60006000,true)
	e:SetLabel(dis)
end
function c511003033.zop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c511003033.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabel(e:GetLabel())
	c:RegisterEffect(e1)
end
function c511003033.zop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c511003033.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabel(e:GetLabel())
	c:RegisterEffect(e1)
end
function c511003033.disop(e,tp)
	return e:GetLabel()
end
