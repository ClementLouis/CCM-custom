--Pumpkingdom
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x2f)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.condition)
	e3:SetOperation(s.countop)
	c:RegisterEffect(e3)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(s.spcost)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	
end
s.counter_place_list={0x2f}
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x2f,1)
end
function s.ctfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsPreviousLocation(LOCATION_GRAVE)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ctfilter,1,nil,tp)
end
function s.val(e,c)
	return Duel.GetCounter(0,1,1,0x2f)*100
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x2f,6,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x2f,6,REASON_COST)
end

function s.spfilter(c,e,tp)
	return c:IsCode(29155212) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummonStep(g,0,tp,tp,false,false,POS_FACEUP) then
		-- Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		--set Call of the haunted
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.setcon)
		e1:SetTarget(s.settg)
		e1:SetOperation(s.setop)
		c:RegisterEffect(e1)
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetCondition(s.indcon)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		--
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(s.indcon)
		e3:SetValue(1)
		c:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end


function s.cfilter(c,tp)
	return c:GetPreviousControler()==tp and re:GetOwner()==c and c:IsReason(REASON_DESTROY)
		and c:IsCode(97077563) and c:IsPreviousPosition(POS_FACEUP)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.setfilter(c)
	return c:IsCode(97077563) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		if tc.act_turn then
			local e0=Effect.CreateEffect(tc)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e0)
		end
	end
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,97077563),tp,LOCATION_ONFIELD,0,1,nil)
end
