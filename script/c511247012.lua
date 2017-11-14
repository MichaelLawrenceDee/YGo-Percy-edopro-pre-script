--時の機械－タイム・マシーン
--fixed by MLD
function c511247012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetTarget(c511247012.target)
	e1:SetOperation(c511247012.activate)
	c:RegisterEffect(e1)
end
function c511247012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tc:GetPreviousControler(),LOCATION_MZONE)>0 and eg:GetCount()==1
		and tc:IsLocation(LOCATION_GRAVE) end
	Duel.SetTargetCard(tc)
end
function c511247012.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tc:GetPreviousControler(),tc:GetPreviousControler(),LOCATION_MZONE,tc:GetPreviousPosition(),true)
		tc:SetStatus(STATUS_SPSUMMON_STEP,false)
		tc:SetStatus(STATUS_SPSUMMON_TURN,true)
	end
end
