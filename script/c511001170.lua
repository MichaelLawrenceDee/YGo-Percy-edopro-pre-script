--Plate Salvage
function c511001170.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001170.target)
	e1:SetOperation(c511001170.activate)
	c:RegisterEffect(e1)
	if not c511001170.global_check then
		c511001170.global_check=true
		c511001170[0]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:SetCountLimit(1)
		ge1:SetOperation(c511001170.endop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511001170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
end
function c511001170.activate(e,tp,eg,ep,ev,re,r,rp)
	--disable
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FIELD))
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	local descnum=tp==c:GetOwner() and 0 or 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetDescription(aux.Stringid(313513,descnum))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(1082946)
	e3:SetOwnerPlayer(tp)
	e3:SetLabel(0)
	e3:SetOperation(c511001170.reset)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e3)
	table.insert(c511001170[0],e3)
	c511001170[0][e3]={e1,e2}
end
function c511001170.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=e:GetLabel()
	label=label+1
	e:SetLabel(label)
	if ev==1082946 then
		c:SetTurnCounter(label)
	end
	c:SetTurnCounter(0)
	if label==2 then
		local e1,e2=table.unpack(c511001170[0][e])
		e:Reset()
		if e1 then e1:Reset() end
		if e2 then e2:Reset() end
		c511001170[0][e]=nil
		for i,te in ipairs(c511001170[0]) do
			if te==e then
				table.remove(c511001170[0],i)
				break
			end
		end
	end
end
function c511001170.endop(e,tp,eg,ep,ev,re,r,rp)
	for _,te in ipairs(c511001170[0]) do
		c511001170.reset(te,te:GetOwnerPlayer(),nil,0,0,nil,0,0)
	end
end
