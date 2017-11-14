--機関連結
function c60879050.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c60879050.filter,c60879050.eqlimit,c60879050.cost)
	--Atk Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(c60879050.value)
	c:RegisterEffect(e3)
	--Pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c60879050.ftarget)
	c:RegisterEffect(e5)
end
function c60879050.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c60879050.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c60879050.rmfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(10) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c60879050.filterchk(c,g,sg)
	sg:AddCard(c)
	local res
	if sg:GetCount()<2 then
		res=g:IsExists(c60879050.filterchk,1,sg,g,sg)
	else
		res=Duel.IsExistingTarget(c60879050.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	sg:RemoveCard(c)
	return res
end
function c60879050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60879050.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:IsExists(c60879050.filterchk,1,nil,g,Group.CreateGroup()) end
	local rg=Group.CreateGroup()
	while rg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,c60879050.filterchk,1,1,rg,g,rg)
		rg:Merge(sg)
	end
end
function c60879050.value(e,c)
	return c:GetBaseAttack()*2
end
function c60879050.ftarget(e,c)
	return e:GetHandler():GetEquipTarget()~=c
end
