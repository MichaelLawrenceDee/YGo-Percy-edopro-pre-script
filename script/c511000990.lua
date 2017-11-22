--Yasushi the Skull Knight
function c511000990.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c:Type(TYPE_MONSTER+TYPE_NORMAL+TYPE_FUSION)
	aux.AddFusionProcMix(c,true,true,78010363,80604091)
	if not c511000990.global_check then
		c511000990.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		ge2:SetTargetRange(LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE+LOCATION_HAND)
		ge2:SetTarget(c511000990.mttg)
		ge2:SetValue(c511000990.mtval)
		Duel.RegisterEffect(ge2,0)
	end
end
c511000990.illegal=true
function c511000990.mttg(e,c)
	return (c:IsCode(80604091) or c:GetOriginalCode()==80604091 or c:GetOriginalCode()==511003023)
end
function c511000990.mtval(e,c)
	if not c then return false end
	return c:GetOriginalCode()==511000990
end
