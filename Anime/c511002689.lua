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
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_DRAGON)
		c:RegisterEffect(e1)
		table.insert(Auxiliary.SynchroReset,e1)
		return true
		--c:AssumeProperty(ASSUME_RACE,RACE_DRAGON)
	else return false
	end
end
