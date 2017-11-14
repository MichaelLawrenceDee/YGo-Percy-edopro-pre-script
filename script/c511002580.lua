--Ordeal of the Hero
function c511002580.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c511002580.condition)
	e1:SetTarget(c511002580.target)
	e1:SetOperation(c511002580.activate)
	c:RegisterEffect(e1)
	if not c511002580.global_check then
		c511002580.global_check=true
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetCountLimit(1)
		ge4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge4:SetOperation(c511002580.archchk)
		Duel.RegisterEffect(ge4,0)
	end
end
function c511002580.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002580.cfilter(c)
	return c:IsFaceup() and c:IsComicsHero()
end
function c511002580.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(c511002580.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511002580.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsFaceup() and tc:IsOnField() and Duel.IsPlayerCanSpecialSummon(1-tp) 
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>1 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,1-tp,LOCATION_DECK)
end
function c511002580.spfilter(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002580.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c511002580.spfilter,tp,0,LOCATION_DECK,nil,e,1-tp,tc:GetLevel())
		if g:GetCount()>=2 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(1-tp,2,2,nil)
			local spc=sg:GetFirst()
			while spc do
				Duel.SpecialSummonStep(spc,0,1-tp,1-tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				spc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				spc:RegisterEffect(e2,true)
				spc=sg:GetNext()
			end
			Duel.SpecialSummonComplete()
		else
			Duel.Damage(1-tp,400,REASON_EFFECT)
		end
	end
end
