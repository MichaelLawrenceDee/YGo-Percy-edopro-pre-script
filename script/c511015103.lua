--D/D/D Xyz
function c511015103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511015103.target)
	e1:SetOperation(c511015103.activate)
	c:RegisterEffect(e1)
end
function c511015103.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsSetCard(0x10af) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511015103.mfilter(c,g,sg,tp,ft,ftex,ftt,ect,e,chk)
	sg:AddCard(c)
	if ftt<=0 then return false end
	local ftt=ftt-1
	local res
	if c:IsLocation(LOCATION_EXTRA) then
		if ftex<=0 then return false end
		if ect then
			if ect<=0 then return false end
			ect=ect-1
		end
		ftex=ftex-1
		local res=((not chk or ftt==0 or ect==0) and Duel.IsExistingMatchingCard(c511015103.xyzfilter,tp,LOCATION_EXTRA,0,1,sg,sg,e)) 
			or g:IsExists(c511015103.mfilter,1,sg,g,sg,tp,ft,ftex,ftt,ect,e,chk)
		ftex=ftex+1
		if ect then
			ect=ect+1
		end
	else
		if ft<=0 then return false end
		ft=ft-1
		local res=((not chk or ftt==0 or ect==0) and Duel.IsExistingMatchingCard(c511015103.xyzfilter,tp,LOCATION_EXTRA,0,1,sg,sg,e)) 
			or g:IsExists(c511015103.mfilter,1,sg,g,sg,tp,ft,ftex,ftt,ect,e,chk)
		ft=ft+1
	end
	sg:RemoveCard(c)
	return res
end
function c511015103.xyzfilter(c,sg,e)
	local ct=sg:GetCount()
	local mc=e:GetHandler()
	local e1=nil
	if sg:IsExists(Card.IsCode,1,nil,47198668) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e1=Effect.CreateEffect(mc)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(511002116)
		e1:SetReset(RESET_CHAIN)
		mc:RegisterEffect(e1)
	end
	local res=c:IsXyzSummonable(sg,ct,ct)
	if e1 then e1:Reset() end
	return res
end
function c511015103.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c511015103.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	local ftex=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ftt=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]-1
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and ftt>1 then ftt=1 end
	local sg=Group.CreateGroup()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and mg:IsExists(c511015103.mfilter,1,nil,mg,sg,tp,ft,ftex,ftt,ect,e) end
	local tc
	::start::
		local cancel=sg:GetCount()>0 and Duel.IsExistingMatchingCard(c511015103.xyzfilter,tp,LOCATION_EXTRA,0,1,sg,sg,mc)
		local tg=mg:Filter(c511015103.mfilter,sg,mg,sg,tp,ft,ftex,ftt,ect,e)
		if tg:GetCount()<=0 then goto jump end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		tc=Group.SelectUnselect(tg,sg,tp,cancel,cancel)
		if not tc then goto jump end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
			ftt=ftt+1
			if tc:IsLocation(LOCATION_EXTRA) then
				ect=ect+1
				ftex=ftex+1
			else
				ft=ft+1
			end
		else
			sg:AddCard(tc)
			ftt=ftt-1
			if tc:IsLocation(LOCATION_EXTRA) then
				ect=ect-1
				ftex=ftex-1
			else
				ft=ft-1
			end
		end
		goto start
	::jump::
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511015103.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and g:GetCount()>1 then return end
	local ftt=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ftt<g:GetCount() or (ect and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)>ect) then
		local ftex=Duel.GetLocationCountFromEx(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sg=Group.CreateGroup()
		local tc
		::start::
			local cancel=sg:GetCount()>0 and (ftt==0 or ect==0) and Duel.IsExistingMatchingCard(c511015103.xyzfilter,tp,LOCATION_EXTRA,0,1,sg,sg,mc)
			local tg=g:Filter(c511015103.mfilter,sg,g,sg,tp,ft,ftex,ftt,ect,e,true)
			if tg:GetCount()<=0 then goto jump end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tc=Group.SelectUnselect(tg,sg,tp,cancel,cancel)
			if not tc then goto jump end
			if sg:IsContains(tc) then
				sg:RemoveCard(tc)
				ftt=ftt+1
				if tc:IsLocation(LOCATION_EXTRA) then
					ect=ect+1
					ftex=ftex+1
				else
					ft=ft+1
				end
			else
				sg:AddCard(tc)
				ftt=ftt-1
				if tc:IsLocation(LOCATION_EXTRA) then
					ect=ect-1
					ftex=ftex-1
				else
					ft=ft-1
				end
			end
			goto start
		::jump::
		if sg:GetCount()<=0 then return false end
		g=sg
	end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local xyzg=Duel.GetMatchingGroup(c511015103.xyzfilter,tp,LOCATION_EXTRA,0,g,g,e)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and g:IsExists(Card.IsCode,1,nil,47198668) then
			e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(511002116)
			e1:SetReset(RESET_CHAIN)
			c:RegisterEffect(e1)
		end
		Duel.XyzSummon(tp,xyz,g)
	end
end
