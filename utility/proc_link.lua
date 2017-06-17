
--Link Summon
function Auxiliary.AddLinkProcedure(c,f,min,max)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max))
	e1:SetTarget(Auxiliary.LinkTarget(f,min,max))
	e1:SetOperation(Auxiliary.LinkOperation(f,min,max))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--link limitations
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_TURN_SET)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(Auxiliary.LinkSpLimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	c:RegisterEffect(e5)
end
function Auxiliary.LinkSpLimit(e,se,sp,st)
	return bit.band(sp,POS_ATTACK)>0
end
function Auxiliary.LConditionFilter(c,f)
	return c:IsFaceup() and (not f or f(c))
end
function Auxiliary.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function Auxiliary.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.LCheckGoal(tp,sg,lc,minc,ct)
		or (ct<maxc and mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.LCheckGoal(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Auxiliary.LinkCondition(f,minc,maxc)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f)
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.LCheckRecursive,1,nil,tp,sg,mg,c,0,minc,maxc)
			end
end
function Auxiliary.LinkTarget(f,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f)
				local sg=Group.CreateGroup()
				local cancel=false
				while sg:GetCount()<maxc do
					local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,sg:GetCount(),minc,maxc)
					if cg:GetCount()==0 then break end
					if sg:GetCount()>minc and sg:GetCount()<=maxc and Auxiliary.LCheckGoal(tp,sg,c,minc,sg:GetCount()) then
						cancel=true 
					else 
						cancel=false
					end
					local tc=Group.SelectUnselect(cg,sg,tp,cancel,sg:GetCount()==0 or cancel,1,1)
					if not tc then break end
					if not sg:IsContains(tc) then
						sg:AddCard(tc)
					else
						sg:RemoveCard(tc)
					end
				end
				if sg:GetCount()>0 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function Auxiliary.LinkOperation(f,min,max)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end