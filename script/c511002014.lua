--Supreme Thunder Star Raijin
function c511002014.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,function(c) return c:IsSky(true) end,function(c) return c:IsEarth(true) end)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	aux.CallToken(420)
end
c511002014.material_setcode={0x54a,0x51a}
