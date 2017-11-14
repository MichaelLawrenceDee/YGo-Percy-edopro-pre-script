--終焉のカウントダウン
function c95308449.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c95308449.cost)
	e1:SetOperation(c95308449.activate)
	c:RegisterEffect(e1)
	if not c95308449.global_check then
		c95308449.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:SetCountLimit(1)
		ge1:SetOperation(c95308449.endop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c95308449.winop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c95308449.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c95308449.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(95308449)
	e1:SetOperation(c95308449.checkop)
	e1:SetCountLimit(1)
	e1:SetLabel(0)
	e1:SetValue(0)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END,21)
	Duel.RegisterEffect(e1,tp)
	local descnum=tp==c:GetOwner() and 0 or 1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetDescription(aux.Stringid(95308449,descnum))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(1082946)
	e2:SetLabelObject(e1)
	e2:SetOwnerPlayer(tp)
	e2:SetOperation(c95308449.reset)
	e2:SetReset(RESET_PHASE+PHASE_END,21)
	c:RegisterEffect(e2)
end
function c95308449.reset(e,tp,eg,ep,ev,re,r,rp)
	c95308449.checkop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function c95308449.endop(e,tp,eg,ep,ev,re,r,rp)
	local eff={Duel.GetPlayerEffect(tp,95308449)}
	for _,te in ipairs(eff) do
		c95308449.checkop(te,te:GetOwnerPlayer(),nil,0,0,nil,0,0)
	end
	c95308449.winop(e,tp,eg,ep,ev,re,r,rp)
end
function c95308449.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetValue()
	ct=ct+1
	e:GetHandler():SetTurnCounter(ct)
	e:SetValue(ct)
	if ct==20 then
		if re then re:Reset() end
	end
end
function c95308449.winop(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	t[0]=0
	t[1]=0
	local eff={Duel.GetPlayerEffect(tp,95308449)}
	for _,te in ipairs(eff) do
		local p=te:GetOwnerPlayer()
		local ct=te:GetValue()
		if ct==20 then
			t[p]=t[p]+1
			local label=te:GetLabel()+1
			if label==3 then
				te:Reset()
			end
		end
	end
	if t[0]>0 or t[1]>0 then
		if t[0]==t[1] then
			Duel.Win(PLAYER_NONE,0x11)
		elseif t[0]>t[1] then
			Duel.Win(0,0x11)
		else
			Duel.Win(1,0x11)
		end
	end
end
