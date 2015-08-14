--Angler
function c201.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(201,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c201.spcon)
	e2:SetTarget(c201.sptg)
	e2:SetOperation(c201.spop)
	c:RegisterEffect(e2)
end
function c201.spfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x12e)
end
function c201.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c201.spfilter,1,nil,tp)
end
function c201.tdfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra() and c:IsSetCard(0x12e)
end
function c201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c201.tdfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND)
end
function c201.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c201.tdfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MovetoExtraDeck(g,nil,0,REASON_EFFECT)
	end
end
