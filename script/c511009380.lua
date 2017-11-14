--SR fiendmagnet
function c511009380.initial_effect(c)
	--synchro
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(83236601,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c511009380.spcon)
	e2:SetTarget(c511009380.sptg)
	e2:SetOperation(c511009380.spop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(73941492+TYPE_SYNCHRO)
	e4:SetValue(c511009380.synlimit)
	c:RegisterEffect(e4)
	if not c511009380.global_check then
		c511009380.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(511009380)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(511009380)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511009380.synlimit(e,c)
	return c:IsControler(1-e:GetHandlerPlayer())
end
function c511009380.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(511009380)>0
end
function c511009380.filter(c,tp,tc)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c511009380.synfilter,tp,LOCATION_EXTRA,0,1,nil,tc,c)
end
function c511009380.synfilter(sc,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
	e1:SetReset(RESET_CHAIN)
	tc:RegisterEffect(e1)
	local g=Group.FromCards(c,tc)
	local res=sc:IsSynchroSummonable(nil,g)
	e1:Reset()
	return res
end
function c511009380.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c511009380.filter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c511009380.filter,tp,0,LOCATION_MZONE,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	Duel.SelectTarget(tp,c511009380.filter,tp,0,LOCATION_MZONE,1,1,nil,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511009380.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(c511009380.synfilter,tp,LOCATION_EXTRA,0,nil,c,tc)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,Group.FromCards(c,tc))
		end
	end
end
