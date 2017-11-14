--EMオッドアイズ・シンクロン
function c511003045.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--eff
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511003045.indcon)
	e1:SetOperation(c511003045.indop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8873112,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(LOCATION_PZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c511003045.indcon2)
	e2:SetTarget(c511003045.indtg)
	e2:SetOperation(c511003045.indop2)
	c:RegisterEffect(e2)
	--synchro
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82224646,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c511003045.sctg)
	e4:SetOperation(c511003045.scop)
	c:RegisterEffect(e4)
end
function c511003045.indcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsType(TYPE_TUNER) and tc:IsControler(tp) and tc:IsRelateToBattle()
end
function c511003045.indop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	if not tc or tc:IsControler(1-tp) or not tc:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
end
function c511003045.cfilter(c,e,tp)
	return c:IsOnField() and c:IsControler(tp) and c:IsType(TYPE_TUNER) and (not e or c:IsRelateToEffect(e))
end
function c511003045.indcon2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c511003045.cfilter,nil,nil,tp)-tg:GetCount()>0
end
function c511003045.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	Duel.SetTargetCard(tg)
end
function c511003045.indop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(c511003045.cfilter,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c511003045.scfilter1(c,tp,mc)
	return Duel.IsExistingMatchingCard(c511003045.scfilter2,tp,LOCATION_PZONE,0,1,nil,mc,c)
end
function c511003045.scfilter2(c,mc,sc)
	local mg=Group.FromCards(c,mc)
	return c:IsCanBeSynchroMaterial(sc) and sc:IsSynchroSummonable(nil,mg)
end
function c511003045.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(c511003045.scfilter1,tp,LOCATION_EXTRA,0,1,nil,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511003045.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp,tp,c)<=0 then return end
	local g=Duel.GetMatchingGroup(c511003045.scfilter1,tp,LOCATION_EXTRA,0,nil,tp,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mg=Duel.SelectMatchingCard(tp,c511003045.scfilter2,tp,LOCATION_PZONE,0,1,1,nil,c,sc)
		mg:AddCard(c)
		Duel.SynchroSummon(tp,sc,nil,mg)
	end
end
