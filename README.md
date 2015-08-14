# YGOPro-Sending-Pendulum-Monsters-directly-to-the-Extra-Deck
For the Pendulum effect of Abyssive Angler
When an "Abyssive" monster(s) is Special Summoned, you can place 1 "Abyssive" Pendulum Monster from your hand, Deck or Graveyard face-up into your Extra Deck. You can only activate this effect of "Abyssive Angler" once per turn.
Using Notepad++
The main problem lies in line 52. I tried various from cards that return Extra Deck Monsters to the ED but in the code do that via SendtoDeck which, because of the mechanics of those monsters, works. But Pendulum Monsters can be in the Main Deck too and the same principle won't for them. I left it just so you know what I want help with.

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
