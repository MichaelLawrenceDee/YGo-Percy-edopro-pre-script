--Rank-Up-Magic Cipher Pursuit
--cleaned up by MLD
function c511018510.initial_effect(c)
	--Activate
	local re1=Effect.CreateEffect(c)
	re1:SetDescription(aux.Stringid(41201386,0))
	re1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	re1:SetType(EFFECT_TYPE_ACTIVATE)
	re1:SetCode(EVENT_FREE_CHAIN)
	re1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	re1:SetCondition(c511018510.condition)
	re1:SetTarget(c511018510.target)
	re1:SetOperation(c511018510.activate)
	c:RegisterEffect(re1)
end
function c511018510.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>Duel.GetLP(1-tp) then
		return Duel.GetLP(tp)-Duel.GetLP(1-tp)>=2000
	else
		return Duel.GetLP(1-tp)-Duel.GetLP(tp)>=2000
	end
end
function c511018510.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xe5) 
		and Duel.IsExistingMatchingCard(c511018510.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
end
function c511018510.filter2(c,e,tp,mc,rk)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return c:GetRank()==rk and c:IsSetCard(0xe5) and mc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c511018510.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511018510.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511018510.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511018510.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511018510.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511018510.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if not sc:IsHasEffect(511002571) then return end
		local eff={sc:GetCardEffect(511002571)}
		local te=nil
		local acd={}
		local ac={}
		for i=1,#eff do
			local temp=eff[i]:GetLabelObject()
			local tg=temp:GetTarget()
			if not tg or tg(temp,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[i],REASON_EFFECT,PLAYER_NONE,0) then
				table.insert(ac,temp)
				table.insert(acd,temp:GetDescription())
			end
		end
		if #ac<=0 or not Duel.SelectYesNo(tp,aux.Stringid(48680970,0)) then return end
		Duel.BreakEffect()
		if #ac==1 then te=ac[1] elseif #ac>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			op=Duel.SelectOption(tp,table.unpack(acd))
			op=op+1
			te=ac[op]
		end
		if not te then return end
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if tg then tg(te,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[1],REASON_EFFECT,PLAYER_NONE,1) end
		Duel.BreakEffect()
		sc:CreateEffectRelation(te)
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[1],REASON_EFFECT,PLAYER_NONE,1) end
		sc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end
