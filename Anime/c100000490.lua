--デステニー・オーバーレイ
function c100000490.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000490.target)
	e1:SetOperation(c100000490.activate)
	c:RegisterEffect(e1)
end
function c100000490.filter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and not c:IsType(TYPE_TOKEN)
end
function c100000490.cfilter(c)
	return not c:IsHasEffect(EFFECT_XYZ_MATERIAL)
end
function c100000490.mfilter(c,g,matg,tp)
	g:RemoveCard(c)
	matg:AddCard(c)
	local res=Duel.IsExistingMatchingCard(c100000490.xyzfilterchk,tp,LOCATION_EXTRA,0,1,nil,tg)
		and (Duel.IsExistingMatchingCard(c100000490.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,tg,tg:GetCount(),PLAYER_NONE) 
		or g:IsExists(c100000490.mfilter,1,nil,mg,tg,tp))
	g:AddCard(c)
	matg:RemoveCard(c)
	return res
end
function c100000490.xyzfilterchk(c,mg)
	return not mg:IsExists(function(mc) return c.xyz_filter and not c.xyz_filter(mc) end,1,nil) and c.maxxyzct and mg:GetCount()<=c.maxxyzct
end
function c100000490.xyzfilter(c,mg,ct,tp)
	if tp~=PLAYER_NONE then
		local g=mg:Filter(Card.IsControler,nil,tp)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_XYZ_MATERIAL)
			e1:SetReset(RESET_EVENT+RESET_MSCHANGE)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
	local res=false
	if not ct then
		res=c:IsXyzSummonable(mg)
	else
		res=c:IsXyzSummonable(mg,ct,ct)
	end
	if tp~=PLAYER_NONE then
		tc=g:GetFirst()
		while tc do
			tc:ResetEffect(RESET_MSCHANGE,RESET_EVENT)
			tc=g:GetNext()
		end
	end
	return res
end
function c100000490.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c100000490.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000490.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg,nil,tp) end
	local g=mg:Filter(Card.IsControler,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_XYZ_MATERIAL)
		e1:SetReset(RESET_EVENT+RESET_MSCHANGE)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local tg=Group.CreateGroup()
	while not Duel.IsExistingMatchingCard(c100000490.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,tg,tg:GetCount()) 
		or (mg:IsExists(c100000490.mfilter,1,nil,mg,tg,tp) and Duel.SelectYesNo(tp,513)) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=mg:FilterSelect(tp,c100000490.mfilter,1,1,nil,mg,tg,tp)
		local tc=sg:GetFirst()
		mg:RemoveCard(tc)
		tg:AddCard(tc)
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	tc=g:GetFirst()
	while tc do
		tc:ResetEffect(RESET_MSCHANGE,RESET_EVENT)
		tc=g:GetNext()
	end
end
function c100000490.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_MATERIAL)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local xyzg=Duel.GetMatchingGroup(c100000490.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,g:GetCount(),PLAYER_NONE)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
