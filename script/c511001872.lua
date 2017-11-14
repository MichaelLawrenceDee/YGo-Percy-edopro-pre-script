--Self Tribute
function c511001872.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511001872.condition)
	e1:SetCost(c511001872.cost)
	e1:SetTarget(c511001872.target)
	e1:SetOperation(c511001872.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c511001872.condition2)
	c:RegisterEffect(e2)
end
function c511001872.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if not tc or not bc or (tc:IsControler(1-tp) and bc:IsControler(1-tp)) then return false end
	local tcindes=false
	local bcindes=false
	if tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={tc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,#tcind do
			local te=tcind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,bc) then tcindes=true end
			else tcindes=true end
		end
	end
	if bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={bc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,#tcind do
			local te=tcind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,tc) then bcindes=true end
			else bcindes=true end
		end
	end
	if tcindes and bcindes then return false end
	local g=Group.CreateGroup()
	if (bc~=Duel.GetAttackTarget() or bc:IsAttackPos()) and tc:IsControler(tp) then
		if bc:IsPosition(POS_FACEUP_DEFENSE) and bc==Duel.GetAttacker() then
			if bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
				if bc:IsHasEffect(75372290) then
					if tc:IsAttackPos() then
						if bc:GetAttack()>0 and bc:GetAttack()>=tc:GetAttack() then
							g:AddCard(tc)
						end
					else
						if bc:GetAttack()>tc:GetDefense() then
							g:AddCard(tc)
						end
					end
				else
					if tc:IsAttackPos() then
						if bc:GetDefense()>0 and bc:GetDefense()>=tc:GetAttack() then
							g:AddCard(tc)
						end
					else
						if bc:GetDefense()>tc:GetDefense() then
							g:AddCard(tc)
						end
					end
				end
			end
		else
			if tc:IsAttackPos() then
				if bc:GetAttack()>0 and bc:GetAttack()>=tc:GetAttack() then
					g:AddCard(tc)
				end
			else
				if bc:GetAttack()>tc:GetDefense() then
					g:AddCard(tc)
				end
			end
		end
	end
	if (tc~=Duel.GetAttackTarget() or tc:IsAttackPos()) and bc:IsControler(tp) then
		if tc:IsPosition(POS_FACEUP_DEFENSE) and tc==Duel.GetAttacker() then
			if tc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
				if tc:IsHasEffect(75372290) then
					if bc:IsAttackPos() then
						if tc:GetAttack()>0 and tc:GetAttack()>=bc:GetAttack() then
							g:AddCard(bc)
						end
					else
						if tc:GetAttack()>bc:GetDefense() then
							g:AddCard(bc)
						end
					end
				else
					if bc:IsAttackPos() then
						if tc:GetDefense()>0 and tc:GetDefense()>=bc:GetAttack() then
							g:AddCard(bc)
						end
					else
						if tc:GetDefense()>bc:GetDefense() then
							g:AddCard(bc)
						end
					end
				end
			end
		else
			if bc:IsAttackPos() then
				if tc:GetAttack()>0 and tc:GetAttack()>=bc:GetAttack() then
					g:AddCard(bc)
				end
			else
				if tc:GetAttack()>bc:GetDefense() then
					g:AddCard(bc)
				end
			end
		end
	end
	if g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c511001872.cfilter(c,e,tp)
	return c:IsOnField() and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c511001872.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if tg==nil then return false end
	local g=tg:Filter(c511001872.cfilter,nil,nil,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return ex and tc+g:GetCount()-tg:GetCount()>0
end
function c511001872.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c511001872.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g end
	Duel.SetTargetCard(g)
end
function c511001872.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c511001872.cfilter,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
