--Ancient Gear Triple Bite Hound Dog
function c511001544.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c511001544.material_count=2
	c511001544.material={42878636,511001540}
	c511001544.min_material_count=2
	c511001544.max_material_count=3
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetDescription(aux.Stringid(4006,13))
	e0:SetCondition(aux.FConditionMix(true,true,c511001544.fil1,c511001544.fil1,c511001544.fil1))
	e0:SetOperation(aux.FOperationMix(true,true,c511001544.fil1,c511001544.fil1,c511001544.fil1))
	c:RegisterEffect(e0)
	local e0a=e0:Clone()
	e0a:SetDescription(aux.Stringid(4006,14))
	e0a:SetCondition(aux.FConditionMix(true,true,c511001544.fil1,c511001544.fil2))
	e0a:SetOperation(aux.FOperationMix(true,true,c511001544.fil1,c511001544.fil2))
	c:RegisterEffect(e0a)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c511001544.atkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(2)
	c:RegisterEffect(e2)
end
c511001544.material_setcode=0x7
function c511001544.fil1(c,fc,sub1,sub2)
	return c:IsFusionCode(42878636) or (sub and c:CheckFusionSubstitute(fc)) or (sub2 and c:IsHasEffect(511002961))
end
function c511001544.fil2(c,fc,sub1,sub2)
	return c:IsFusionCode(511001540) or (sub and c:CheckFusionSubstitute(fc)) or (sub2 and c:IsHasEffect(511002961))
end
function c511001544.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c511001544.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c511001544.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
