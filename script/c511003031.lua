--地盤沈下
function c511003031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511003031.target)
	c:RegisterEffect(e1)
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetOperation(c511003031.disop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c511003031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)>1 
		or not Duel.CheckLocation(tp,LOCATION_MZONE,5) or not Duel.CheckLocation(tp,LOCATION_MZONE,6) 
		or not Duel.CheckLocation(1-tp,LOCATION_MZONE,5) or not Duel.CheckLocation(1-tp,LOCATION_MZONE,6) end
	local dis=Duel.SelectDisableField(tp,2,LOCATION_MZONE,LOCATION_MZONE,0,true)
	e:SetLabel(dis)
end
function c511003031.disop(e,tp)
	return e:GetLabelObject():GetLabel()
end
