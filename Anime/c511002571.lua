--Tachyon Unit
function c511002571.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c511002571.cost)
	e1:SetTarget(c511002571.target)
	e1:SetOperation(c511002571.activate)
	c:RegisterEffect(e1)
end
function c511002571.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c511002571.filter(c,e,tp)
	if not c:IsCode(88177324) and not c:IsCode(68396121) then return false end
	if c:IsFacedown() or not c:IsHasEffect(511002571) then return false end
	local eff={c:GetCardEffect(511002571)}
	for i=1,#eff do
		local te=eff[i]:GetLabelObject()
		local tg=te:GetTarget()
		if not tg or tg(e,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[i],REASON_EFFECT,PLAYER_NONE,0) then return true end
	end
	return false
end
function c511002571.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511002571.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511002571.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	Duel.SelectTarget(tp,c511002571.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c511002571.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local eff={tc:GetCardEffect(511002571)}
		local te=nil
		local acd={}
		local ac={}
		for i=1,#eff do
			local temp=eff[i]:GetLabelObject()
			local tg=temp:GetTarget()
			if not tg or tg(e,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[i],REASON_EFFECT,PLAYER_NONE,0) then
				table.insert(ac,temp)
				table.insert(acd,temp:GetDescription())
			end
		end
		if #ac==1 then te=ac[1] elseif #ac>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			op=Duel.SelectOption(tp,table.unpack(acd))
			op=op+1
			te=ac[op]
		end
		if not te then return end
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if tg then tg(e,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[1],REASON_EFFECT,PLAYER_NONE,1) end
		Duel.BreakEffect()
		tc:CreateEffectRelation(e)
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(e)
				etc=g:GetNext()
			end
		end
		if op then op(e,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[1],REASON_EFFECT,PLAYER_NONE,1) end
		tc:ReleaseEffectRelation(e)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(e)
				etc=g:GetNext()
			end
		end
	end
end
