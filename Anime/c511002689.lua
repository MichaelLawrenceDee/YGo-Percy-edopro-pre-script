--Influence Dragon
function c511002689.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_CHECK)
	e2:SetValue(c511002689.syncheck)
	c:RegisterEffect(e2)
end
function c511002689.syncheck(e,c)
	if c~=e:GetHandler() then
		c:AssumeProperty(ASSUME_RACE,RACE_DRAGON)
		return true
	else return false
	end
end
