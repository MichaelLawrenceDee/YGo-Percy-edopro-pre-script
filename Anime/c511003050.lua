--ＣＣ 隻眼のパスト・アイ
--C/C Critical Eye
function c511003050.initial_effect(c)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(73941492+TYPE_FUSION)
	e4:SetCondition(function(e) return not tempchk end)
	e4:SetValue(c511003050.filter)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(73941492+TYPE_XYZ)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(73941492+TYPE_SYNCHRO)
	c:RegisterEffect(e6)
end
function c511003050.filter(e,c)
	return not c:IsControler(e:GetHandlerPlayer())
end
