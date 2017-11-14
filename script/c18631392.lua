--マアト
function c18631392.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c18631392.spcon)
	e2:SetOperation(c18631392.spop)
	c:RegisterEffect(e2)
	--announce 3 cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18631392,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c18631392.anctg)
	c:RegisterEffect(e3)
end
function c18631392.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c18631392.atchk1,1,nil,sg)
end
function c18631392.atchk1(c,sg)
	return c:IsRace(RACE_FAIRY) and sg:FilterCount(Card.IsRace,c,RACE_DRAGON)==1
end
function c18631392.spfilter(c,rac)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(rac) and c:IsAbleToGraveAsCost()
end
function c18631392.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg1=Duel.GetMatchingGroup(c18631392.spfilter,tp,LOCATION_MZONE,0,nil,RACE_FAIRY)
	local rg2=Duel.GetMatchingGroup(c18631392.spfilter,tp,LOCATION_MZONE,0,nil,RACE_DRAGON)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and rg1:GetCount()>0 and rg2:GetCount()>0
		and aux.SelectUnselectGroup(rg,e,tp,2,2,c18631392.rescon,0)
end
function c18631392.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c18631392.spfilter,tp,LOCATION_MZONE,0,nil,RACE_FAIRY+RACE_DRAGON)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,c18631392.rescon,1,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(g,REASON_COST)
end
function c18631392.anctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanDiscardDeck(tp,3) then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	c18631392.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCardFilter(tp,table.unpack(c18631392.announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac2=Duel.AnnounceCardFilter(tp,table.unpack(c18631392.announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac3=Duel.AnnounceCardFilter(tp,table.unpack(c18631392.announce_filter))
	e:SetOperation(c18631392.retop(ac1,ac2,ac3))
end
function c18631392.hfilter(c,code1,code2,code3)
	return c:IsCode(code1,code2,code3) and c:IsAbleToHand()
end
function c18631392.retop(code1,code2,code3)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
			local c=e:GetHandler()
			Duel.ConfirmDecktop(tp,3)
			local g=Duel.GetDecktopGroup(tp,3)
			local hg=g:Filter(c18631392.hfilter,nil,code1,code2,code3)
			g:Sub(hg)
			if hg:GetCount()~=0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hg)
				Duel.ShuffleHand(tp)
			end
			if g:GetCount()~=0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			end
			if c:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(hg:GetCount()*1000)
				e1:SetReset(RESET_EVENT+0x1ff0000)
				c:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				c:RegisterEffect(e2)
			end
		end
end
