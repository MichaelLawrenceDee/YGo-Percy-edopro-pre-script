--メタルフォーゼ・カーディナル
function c54401832.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe1),1,aux.FilterBoolFunction(Card.IsAttackBelow,3000),2)
end
c54401832.material_setcode=0xe1
