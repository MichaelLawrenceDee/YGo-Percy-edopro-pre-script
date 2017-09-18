--Generate Effect
function c419.initial_effect(c)
	if not c419.global_check then
		c419.global_check=true
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

function c419.op5(e,tp,eg,ep,ev,re,r,rp)
	--ATK = 285, prev ATK = 284
	--LVL = 585, prev LVL = 584
	--DEF = 385, prev DEF = 384
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil)
	if not g then return end
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(285)==0 and tc:GetFlagEffect(585)==0 then
			local atk=tc:GetAttack()
			local def=tc:GetDefense()
			if atk<=0 then
				tc:RegisterFlagEffect(285,nil,0,1,0)
				tc:RegisterFlagEffect(284,nil,0,1,0)
			else
				tc:RegisterFlagEffect(285,nil,0,1,atk)
				tc:RegisterFlagEffect(284,nil,0,1,atk)
			end
			if def<=0 then
				tc:RegisterFlagEffect(385,nil,0,1,0)
				tc:RegisterFlagEffect(384,nil,0,1,0)
			else
				tc:RegisterFlagEffect(385,nil,0,1,atk)
				tc:RegisterFlagEffect(384,nil,0,1,atk)
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
function c419.defcfilter(c)
	if c:GetFlagEffect(385)==0 then return false end
	return c:GetDefense()~=c:GetFlagEffectLabel(385)
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
	
	local dg=Duel.GetMatchingGroup(c419.defcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g5=Group.CreateGroup() --change def
	--local g6=Group.CreateGroup() --gain def
	--local g7=Group.CreateGroup() --lose def
	--local g8=Group.CreateGroup() --gain def from original
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
	
	local dc=dg:GetFirst()
	while dc do
		local prevdef=0
		if dc:GetFlagEffect(385)>0 then prevdef=dc:GetFlagEffectLabel(385) end
		g5:AddCard(dc)
		if prevdef>dc:GetDefense() then
			--g7:AddCard(dc)
		else
			--g6:AddCard(dc)
			if prevdef<=dc:GetBaseDefense() and dc:GetDefense()>dc:GetBaseDefense() then
				--g8:AddCard(dc)
			end
		end
		dc:ResetFlagEffect(384)
		dc:ResetFlagEffect(385)
		if prevdef>0 then
			dc:RegisterFlagEffect(384,nil,0,1,prevdef)
		else
			dc:RegisterFlagEffect(384,nil,0,1,0)
		end
		if dc:GetDefense()>0 then
			dc:RegisterFlagEffect(385,nil,0,1,dc:GetDefense())
		else
			dc:RegisterFlagEffect(385,nil,0,1,0)
		end
		dc=dg:GetNext()
	end
	
	Duel.RaiseEvent(g1,511001265,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g1,511001441,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511000377,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511001762,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511000883,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511009110,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g4,511002546,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g5,511009053,re,REASON_EFFECT,rp,ep,0)
	--Duel.RaiseEvent(g5,???,re,REASON_EFFECT,rp,ep,0)
	
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
	
	local dg=Duel.GetMatchingGroup(c419.defcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g5=Group.CreateGroup() --change def
	--local g6=Group.CreateGroup() --gain def
	--local g7=Group.CreateGroup() --lose def
	--local g8=Group.CreateGroup() --gain def from original
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
	
	local dc=dg:GetFirst()
	while dc do
		local prevdef=0
		if dc:GetFlagEffect(385)>0 then prevdef=dc:GetFlagEffectLabel(385) end
		g5:AddCard(dc)
		if prevdef>dc:GetDefense() then
			--g7:AddCard(dc)
		else
			--g6:AddCard(dc)
			if prevdef<=dc:GetBaseDefense() and dc:GetDefense()>dc:GetBaseDefense() then
				--g8:AddCard(dc)
			end
		end
		dc:ResetFlagEffect(284)
		dc:ResetFlagEffect(285)
		if prevdef>0 then
			dc:RegisterFlagEffect(284,nil,0,1,prevdef)
		else
			dc:RegisterFlagEffect(284,nil,0,1,0)
		end
		if dc:GetAttack()>0 then
			dc:RegisterFlagEffect(285,nil,0,1,dc:GetAttack())
		else
			dc:RegisterFlagEffect(285,nil,0,1,0)
		end
		dc=dg:GetNext()
	end
	
	Duel.RaiseEvent(g1,511001265,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511001762,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511009110,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g4,511002546,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g5,511009053,e,REASON_EFFECT,rp,ep,0)
	
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
