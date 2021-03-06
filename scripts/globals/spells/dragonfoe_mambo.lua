-----------------------------------------
-- Spell: Dragonfoe Mambo
-- Grants evasion bonus to all members.
-----------------------------------------

require("scripts/globals/status");

-----------------------------------------
-- OnSpellCast
-----------------------------------------

function onMagicCastingCheck(caster,target,spell)
	return 0;
end;

function onSpellCast(caster,target,spell)

	local sLvl = caster:getSkillLevel(SKILL_SNG); -- Gets skill level of Singing
    local iLvl = caster:getWeaponSkillLevel(SLOT_RANGED);

    -- Since nobody knows the evasion values for mambo, I'll just make shit up! (aka - same as madrigal)
	local power = 9;

    if (sLvl+iLvl > 130) then
        power = power + math.floor((sLvl+iLvl-130) / 18);
    end
    
	if (power >= 30) then
		power = 30;
	end
    
	local iBoost = caster:getMod(MOD_MAMBO_EFFECT) + caster:getMod(MOD_ALL_SONGS_EFFECT);
    if (iBoost > 0) then
        power = power + 1 + (iBoost-1)*4;
    end
    
    if (caster:hasStatusEffect(EFFECT_SOUL_VOICE)) then
        power = power * 2;
    elseif (caster:hasStatusEffect(EFFECT_MARCATO)) then
        power = power * 1.5;
    end
    caster:delStatusEffect(EFFECT_MARCATO);
    
    local duration = 120;
    duration = duration * ((iBoost * 0.1) + (caster:getMod(MOD_SONG_DURATION_BONUS)/100) + 1);
    
    if (caster:hasStatusEffect(EFFECT_TROUBADOUR)) then
        duration = duration * 2;
    end
    
	if not (target:addBardSong(caster,EFFECT_MAMBO,power,0,duration,caster:getID(), 0, 2)) then
        spell:setMsg(75);
    end

	return EFFECT_MAMBO;
end;