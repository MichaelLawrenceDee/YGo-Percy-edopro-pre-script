--Generate Effect
function c419.initial_effect(c)
	if not c419.global_check then
		c419.global_check=true
		--register for ocg cardians
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetOperation(c419.op4)
		Duel.RegisterEffect(e3,0)
		--register for atk change
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_ADJUST)
		e5:SetOperation(c419.op5)
		Duel.RegisterEffect(e5,0)
		local atkeff=Effect.CreateEffect(c)
		atkeff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		atkeff:SetCode(EVENT_CHAIN_SOLVED)
		atkeff:SetOperation(c419.atkraiseeff)
		Duel.RegisterEffect(atkeff,0)
		local atkadj=Effect.CreateEffect(c)
		atkadj:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		atkadj:SetCode(EVENT_ADJUST)
		atkadj:SetOperation(c419.atkraiseadj)
		Duel.RegisterEffect(atkadj,0)
	end
end
function c419.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,0,0x13,0x13,nil,0xe6)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(227)==0 then
			local code=tc:GetOriginalCode()
			local mt=_G["c" .. code]
			if mt.spe==nil then
				if code==17141718 then
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_IGNITION)
					e1:SetRange(LOCATION_HAND)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c17141718.cfilter,tp,LOCATION_MZONE,0,1,nil)
							and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
					end
				elseif code==81752019 then
					mt.spe=false
					mt.spcon=aux.FALSE()
				elseif code==54135423 then
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_IGNITION)
					e1:SetRange(LOCATION_HAND)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c54135423.cfilter,tp,LOCATION_MZONE,0,1,nil)
							and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
					end
				elseif code==80630522 then
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_IGNITION)
					e1:SetRange(LOCATION_HAND)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c80630522.cfilter,tp,LOCATION_MZONE,0,1,nil)
							and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
					end
				elseif code==16024176 then
					local e1=Effect.CreateEffect(tc)
					e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_HAND)
					e1:SetCode(EFFECT_SPSUMMON_PROC)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c16024176.hspfilter,1,nil)
							and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0xe6,c:GetOriginalType(),c:GetOriginalLevel(),
							c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalRace(),c:GetOriginalAttribute())
					end
				elseif code==57261568 then
					local e1=Effect.CreateEffect(tc)
					e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_HAND)
					e1:SetCode(EFFECT_SPSUMMON_PROC)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c57261568.hspfilter,1,nil)
							and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0xe6,c:GetOriginalType(),c:GetOriginalLevel(),
							c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalRace(),c:GetOriginalAttribute())
					end
				elseif code==94388754 then
					local e1=Effect.CreateEffect(tc)
					e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_HAND)
					e1:SetCode(EFFECT_SPSUMMON_PROC)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c94388754.hspfilter,1,nil)
							and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0xe6,c:GetOriginalType(),c:GetOriginalLevel(),
							c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalRace(),c:GetOriginalAttribute())
					end
				elseif code==43413875 then
					local e1=Effect.CreateEffect(tc)
					e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_HAND)
					e1:SetCode(EFFECT_SPSUMMON_PROC)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c43413875.hspfilter,1,nil)
							and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0xe6,c:GetOriginalType(),c:GetOriginalLevel(),
							c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalRace(),c:GetOriginalAttribute())
					end
				elseif code==21772453 then
					local e1=Effect.CreateEffect(tc)
					e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_HAND)
					e1:SetCode(EFFECT_SPSUMMON_PROC)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c21772453.hspfilter,1,nil)
							and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0xe6,c:GetOriginalType(),c:GetOriginalLevel(),
							c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalRace(),c:GetOriginalAttribute())
					end
				elseif code==89818984 then
					local e1=Effect.CreateEffect(tc)
					e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_HAND)
					e1:SetCode(EFFECT_SPSUMMON_PROC)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c89818984.hspfilter,1,nil)
							and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0xe6,c:GetOriginalType(),c:GetOriginalLevel(),
							c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalRace(),c:GetOriginalAttribute())
					end
				elseif code==16802689 then
					local e1=Effect.CreateEffect(tc)
					e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_HAND)
					e1:SetCode(EFFECT_SPSUMMON_PROC)
					e1:SetCondition(aux.FALSE)
					tc:RegisterEffect(e1)
					mt.spe=e1
					mt.spcon=function(c,e)
						if c==nil or not e then return false end
						local tp=c:GetControler()
						return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c16802689.hspfilter,1,nil)
							and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0xe6,c:GetOriginalType(),c:GetOriginalLevel(),
							c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalRace(),c:GetOriginalAttribute())
					end
				end
			end
			tc:RegisterFlagEffect(227,nil,0,1) 	
		end
		tc=g:GetNext()
	end
end

function c419.op5(e,tp,eg,ep,ev,re,r,rp)
	--ATK = 285, prev ATK = 284
	--LVL = 585, prev LVL = 584
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil)
	if not g then return end
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(285)==0 and tc:GetFlagEffect(585)==0 then
			local atk=tc:GetAttack()
			if atk<=0 then
				tc:RegisterFlagEffect(285,nil,0,1,0)
				tc:RegisterFlagEffect(284,nil,0,1,0)
			else
				tc:RegisterFlagEffect(285,nil,0,1,atk)
				tc:RegisterFlagEffect(284,nil,0,1,atk)
			end
			local lv=tc:GetLevel()
			tc:RegisterFlagEffect(585,nil,0,1,lv)
			tc:RegisterFlagEffect(584,nil,0,1,lv)
		end	
		tc=g:GetNext()
	end
end
function c419.atkcfilter(c)
	if c:GetFlagEffect(285)==0 then return false end
	return c:GetAttack()~=c:GetFlagEffectLabel(285)
end
function c419.lvcfilter(c)
	if c:GetFlagEffect(585)==0 then return false end
	return c:GetLevel()~=c:GetFlagEffectLabel(585)
end
function c419.atkraiseeff(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c419.atkcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=Group.CreateGroup() --change atk
	local g2=Group.CreateGroup() --gain atk
	local g3=Group.CreateGroup() --lose atk
	local g4=Group.CreateGroup() --gain atk from original
	local tc=g:GetFirst()
	while tc do
		local prevatk=0
		if tc:GetFlagEffect(285)>0 then prevatk=tc:GetFlagEffectLabel(285) end
		g1:AddCard(tc)
		if prevatk>tc:GetAttack() then
			g3:AddCard(tc)
		else
			g2:AddCard(tc)
			if prevatk<=tc:GetBaseAttack() and tc:GetAttack()>tc:GetBaseAttack() then
				g4:AddCard(tc)
			end
		end
		tc:ResetFlagEffect(284)
		tc:ResetFlagEffect(285)
		if prevatk>0 then
			tc:RegisterFlagEffect(284,nil,0,1,prevatk)
		else
			tc:RegisterFlagEffect(284,nil,0,1,0)
		end
		if tc:GetAttack()>0 then
			tc:RegisterFlagEffect(285,nil,0,1,tc:GetAttack())
		else
			tc:RegisterFlagEffect(285,nil,0,1,0)
		end
		tc=g:GetNext()
	end
	Duel.RaiseEvent(g1,511001265,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g1,511001441,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511000377,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511001762,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511000883,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511009110,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g4,511002546,re,REASON_EFFECT,rp,ep,0)
	
	local lvg=Duel.GetMatchingGroup(c419.lvcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lvc=lvg:GetFirst()
	while lvc do
		local prevlv=lvc:GetFlagEffectLabel(585)
		lvc:ResetFlagEffect(584)
		lvc:ResetFlagEffect(585)
		lvc:RegisterFlagEffect(584,nil,0,1,prevlv)
		lvc:RegisterFlagEffect(585,nil,0,1,lvc:GetLevel())
		lvc=lvg:GetNext()
	end
	Duel.RaiseEvent(lvg,511002524,re,REASON_EFFECT,rp,ep,0)
	
	Duel.RegisterFlagEffect(tp,285,RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(1-tp,285,RESET_CHAIN,0,1)
end
function c419.atkraiseadj(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,285)~=0 or Duel.GetFlagEffect(1-tp,285)~=0 then return end
	local g=Duel.GetMatchingGroup(c419.atkcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=Group.CreateGroup() --change atk
	local g2=Group.CreateGroup() --gain atk
	local g3=Group.CreateGroup() --lose atk
	local g4=Group.CreateGroup() --gain atk from original
	local tc=g:GetFirst()
	while tc do
		local prevatk=0
		if tc:GetFlagEffect(285)>0 then prevatk=tc:GetFlagEffectLabel(285) end
		g1:AddCard(tc)
		if prevatk>tc:GetAttack() then
			g3:AddCard(tc)
		else
			g2:AddCard(tc)
			if prevatk<=tc:GetBaseAttack() and tc:GetAttack()>tc:GetBaseAttack() then
				g4:AddCard(tc)
			end
		end
		tc:ResetFlagEffect(284)
		tc:ResetFlagEffect(285)
		if prevatk>0 then
			tc:RegisterFlagEffect(284,nil,0,1,prevatk)
		else
			tc:RegisterFlagEffect(284,nil,0,1,0)
		end
		if tc:GetAttack()>0 then
			tc:RegisterFlagEffect(285,nil,0,1,tc:GetAttack())
		else
			tc:RegisterFlagEffect(285,nil,0,1,0)
		end
		tc=g:GetNext()
	end
	Duel.RaiseEvent(g1,511001265,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511001762,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511009110,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g4,511002546,e,REASON_EFFECT,rp,ep,0)
	
	local lvg=Duel.GetMatchingGroup(c419.lvcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lvc=lvg:GetFirst()
	while lvc do
		local prevlv=lvc:GetFlagEffectLabel(585)
		lvc:ResetFlagEffect(584)
		lvc:ResetFlagEffect(585)
		lvc:RegisterFlagEffect(584,nil,0,1,prevlv)
		lvc:RegisterFlagEffect(585,nil,0,1,lvc:GetLevel())
		lvc=lvg:GetNext()
	end
	Duel.RaiseEvent(lvg,511002524,e,REASON_EFFECT,rp,ep,0)
end
