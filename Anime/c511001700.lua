--Cardian - Yanagi ni Ono no Michikaze
function c511001700.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001700,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c511001700.spcost)
	e1:SetTarget(c511001700.sptg)
	e1:SetOperation(c511001700.spop)
	c:RegisterEffect(e1)
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetOperation(c511001700.synop)
	c:RegisterEffect(e3)
	c511001700.spe=e1
	if not c511001700.global_check then
		c511001700.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511001700.cardchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511001700.spcon(c,e)
	if c==nil or not e then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c511001700.filter,1,nil) 
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c511001700.filter(c)
	local re=c:GetReasonEffect()
	local spchk=bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)
	return c:GetLevel()==11 and c:IsSetCard(0xe6)
		and (spchk==0 or (spchk~=0 and (not re or not re:GetHandler():IsSetCard(0xe6) or not re:GetHandler():IsType(TYPE_MONSTER))))
end
function c511001700.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511001700.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c511001700.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c511001700.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511001700.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 then
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			if not tc:IsSetCard(0xe6) or not tc.spcon or not tc.spcon(tc,tc.spe) then
				Duel.BreakEffect()
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
			Duel.ShuffleHand(tp)
		end
	end
end
function c511001700.synop(e,tg,ntg,sg,lv,sc,tp)
	local res=sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,sg:GetCount(),sg:GetCount(),sc) 
		or sg:CheckWithSumEqual(function() return 2 end,lv,sg:GetCount(),sg:GetCount())
	return res,true
end
function c511001700.cardchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
		Duel.CreateToken(tp,419)
		Duel.CreateToken(1-tp,419)
		Duel.RegisterFlagEffect(tp,419,nil,0,1)
		Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
	end
end