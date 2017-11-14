--ゲート・ガーディアン
function c25833572.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c25833572.spcon)
	e1:SetOperation(c25833572.spop)
	c:RegisterEffect(e1)
end
function c25833572.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c25833572.chk,1,nil,sg,Group.CreateGroup(),25955164,62340868,98434877)
end
function c25833572.chk(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c25833572.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function c25833572.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	local g1=rg:Filter(Card.IsCode,nil,25955164)
	local g2=rg:Filter(Card.IsCode,nil,62340868)
	local g3=rg:Filter(Card.IsCode,nil,98434877)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 
		and aux.SelectUnselectGroup(g,e,tp,3,3,c25833572.rescon,0)
end
function c25833572.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,25955164,62340868,98434877)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,c25833572.rescon,1,tp,HINTMSG_RELEASE)
	Duel.Release(g,REASON_COST)
end
