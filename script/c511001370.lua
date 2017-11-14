--Junk Dealer
function c511001370.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511001370.condition)
	e1:SetTarget(c511001370.target)
	e1:SetOperation(c511001370.activate)
	c:RegisterEffect(e1)
end
function c511001370.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsControler(1-tp) and tc:IsSummonType(SUMMON_TYPE_FUSION)
end
function c511001370.mgfilter(c,e,tp,fusc)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_GRAVE) and c:GetReason()&0x40008==0x40008 
		and c:GetReasonCard()==fusc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001370.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local mg=tc:GetMaterial()
	if not mg then return false end
	local mgg=mg:Filter(c511001370.mgfilter,nil,e,tp,tc)
	if chk==0 then return mgg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>mgg:GetCount()-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mgg,mgg:GetCount(),0,0)
end
function c511001370.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local mg=tc:GetMaterial():Filter(aux.NecroValleyFilter(c511001370.mgfilter),nil,e,tp,tc)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=mg:GetCount()-1 then return end
	Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
end
