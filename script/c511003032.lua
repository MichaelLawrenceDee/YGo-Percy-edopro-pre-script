--氷結界に住む魔酔虫
function c511003032.initial_effect(c)
	--dis field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92065772,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c511003032.operation)
	c:RegisterEffect(e1)
end
function c511003032.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 
		and Duel.CheckLocation(tp,LOCATION_MZONE,5) and Duel.CheckLocation(tp,LOCATION_MZONE,6) 
		and Duel.CheckLocation(1-tp,LOCATION_MZONE,5) and Duel.CheckLocation(1-tp,LOCATION_MZONE,6) then return end
	--disable field
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c511003032.disop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e:GetHandler():RegisterEffect(e1)
end
function c511003032.disop(e,tp)
	local dis1=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0,true)
	return dis1
end
