--Cubic Defense
function c511004449.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c511004449.condition)
	e1:SetTarget(c511004449.target)
	e1:SetOperation(c511004449.activate)
	c:RegisterEffect(e1)
end
function c511004449.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(1-tp) then a,d=d,a end
	if not d or d:IsControler(1-tp) then return false end
	if d:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={d:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,#tcind do
			local te=tcind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,a) then return false end
			else return false end
		end
	end
	e:SetLabelObject(d)
	if a:IsPosition(POS_FACEUP_DEFENSE) then
		if not a:IsHasEffect(EFFECT_DEFENSE_ATTACK) or Duel.GetAttacker()~=a then return false end
		if a:IsHasEffect(75372290) then
			if d:IsAttackPos() then
				return a:GetAttack()>0 and a:GetAttack()>=d:GetAttack()
			else
				return a:GetAttack()>d:GetDefense()
			end
		else
			if d:IsAttackPos() then
				return a:GetDefense()>0 and a:GetDefense()>=d:GetAttack()
			else
				return a:GetDefense()>d:GetDefense()
			end
		end
	else
		if d:IsAttackPos() then
			return a:GetAttack()>0 and a:GetAttack()>=d:GetAttack()
		else
			return a:GetAttack()>d:GetDefense()
		end
	end
end
function c511004449.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc end
	Duel.SetTargetCard(tc)
end
function c511004449.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetLabel(tc:GetCode())
		e1:SetLabelObject(tc)
		e1:SetTarget(c511004449.reptg)
		e1:SetValue(c511004449.repval)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511004449.filter(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(code)
end
function c511004449.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsContains(e:GetLabelObject()) and e:GetLabelObject():IsReason(REASON_BATTLE) end
	local g=Duel.GetMatchingGroup(c511004449.filter,tp,LOCATION_HAND,0,nil,e,tp,e:GetLabel())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and g:GetCount()>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	return true
end
function c511004449.repval(e,c)
	return c==e:GetLabelObject()
end
