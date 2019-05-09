--Toon Dark Paladin
--AlphaKretin
function c210310303.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,21296502,61190918)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98502113,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c210310303.discon)
	e1:SetCost(c210310303.discost)
	e1:SetTarget(c210310303.distg)
	e1:SetOperation(c210310303.disop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c210310303.val)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.fuslimit)
	c:RegisterEffect(e3)
	--toon stuff
	--cannot attack
	local t1=Effect.CreateEffect(c)
	t1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	t1:SetCode(EVENT_SUMMON_SUCCESS)
	t1:SetOperation(c210310303.atklimit)
	c:RegisterEffect(t1)
	local t2=t1:Clone()
	t2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(t2)
	local t3=t1:Clone()
	t3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(et)
	--direct attack
	local t4=Effect.CreateEffect(c)
	t4:SetType(EFFECT_TYPE_SINGLE)
	t4:SetCode(EFFECT_DIRECT_ATTACK)
	t4:SetCondition(c210310303.dircon)
	c:RegisterEffect(t4)
end
c210310303.material_setcode={0x10a2,0xd7,0x62}
function c210310303.val(e,c)
	return Duel.GetMatchingGroupCount(c210310303.filter,0,0x14,0x14,nil)*500
end
function c210310303.filter(c)
	return c:IsRace(RACE_DRAGON) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c210310303.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c210310303.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c210310303.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c210310303.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c210310303.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c210310303.dirfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c210310303.dirfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c210310303.dircon(e)
	return Duel.IsExistingMatchingCard(c210310303.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c210310303.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end