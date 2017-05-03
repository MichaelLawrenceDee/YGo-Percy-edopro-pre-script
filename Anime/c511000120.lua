--Cursed Twin Dolls
function c511000120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c511000120.activate)
	c:RegisterEffect(e1)
end
function c511000120.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c511000120.rmtarget(e,c)
	return not c:IsLocation(0x80) and e:GetLabel()==c:GetControler() and not c:IsType(TYPE_MONSTER)
end
function c511000120.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p=Duel.GetRandomNumber(1)
	Duel.Hint(HINT_MESSAGE,p,aux.Stringid(4003,0))
	Duel.Hint(HINT_MESSAGE,1-p,aux.Stringid(4003,1))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabel(p)
	e1:SetOperation(c511000120.recop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(c511000120.rmfilter,1-p,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c511000120.rmtarget)
	e2:SetLabel(1-p)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(1-p)
	e3:SetCondition(c511000120.con)
	e3:SetOperation(c511000120.op)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
end
function c511000120.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(e:GetLabel(),eg:GetCount()*200,REASON_EFFECT)
end
function c511000120.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetLabel() and Duel.GetFieldGroupCount(e:GetLabel(),LOCATION_MZONE,0,nil)==0
end
function c511000120.op(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	if Duel.SelectYesNo(p,aux.Stringid(92266279,3)) then
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,5,nil,TYPE_MONSTER)
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UNRELEASABLE_SUM)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e4,true)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e5:SetValue(LOCATION_REMOVED)
			e5:SetReset(RESET_EVENT+0x7e0000)
			tc:RegisterEffect(e5)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e6:SetValue(1)
			e6:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e6)
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e7:SetValue(1)
			tc:RegisterEffect(e7)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e8:SetRange(LOCATION_MZONE)
			e8:SetCode(EFFECT_IMMUNE_EFFECT)
			e8:SetReset(RESET_EVENT+0x1fe0000)
			e8:SetValue(1)
			tc:RegisterEffect(e8)
			tc=g:GetNext()
		end
	end
end
