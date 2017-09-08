--Earthbound Disciple Geo Glasya-Labolas
function c511002721.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,c511002721.fusfilter1,c511002721.fusfilter2)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511002721.atkcon)
	e1:SetOperation(c511002721.atkop)
	c:RegisterEffect(e1)
end
c511002721.material_setcode={0x151a,0x351a}
c511002721.miracle_synchro_fusion=true
function c511002721.fusfilter1(c,fc,sumtype,tp)
	return c:IsSetCard(0x351a) and c:IsType(TYPE_FUSION,fc,sumtype,tp)
end
function c511002721.fusfilter2(c,fc,sumtype,tp)
	return c:IsSetCard(0x351a) and c:IsType(TYPE_SYNCHRO,fc,sumtype,tp)
end
function c511002721.cfilter(tc)
	return tc and tc:IsFaceup()
end
function c511002721.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp) and (bc:IsType(TYPE_FUSION) or bc:IsType(TYPE_SYNCHRO)) and bc:IsFaceup()
		and (c511002721.cfilter(Duel.GetFieldCard(tp,LOCATION_SZONE,5)) or c511002721.cfilter(Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)))
end
function c511002721.atkop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		bc:RegisterEffect(e1)
	end
end
