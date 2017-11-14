--Blue-Eyes White Dragon (DM)
--Scripted by edo9300
function c511000559.initial_effect(c)
	--attack first
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_FIRST_TURN)
	e1:SetRange(0xff)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c511000559.con)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(0xff)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c511000559.con2)
	e2:SetTarget(c511000559.ftarget)
	c:RegisterEffect(e2)
	aux.CallToken(300)
end
c511000559.dm=true
function c511000559.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDeckMaster() and Duel.IsExistingMatchingCard(function(c)return c:IsType(TYPE_FUSION)end,tp,LOCATION_MZONE,0,1,nil)
end
function c511000559.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1 and e:GetHandler():IsDeckMaster()
end
function c511000559.ftarget(e,c)
	return not c:IsType(TYPE_FUSION)
end
