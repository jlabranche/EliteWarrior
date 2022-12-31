if UnitClass("player") == "Warrior" then
    EliteWarrior.BSA = CreateFrame("Frame", nil, UIParent);

    local BSA_Texture = "Interface\\Icons\\Ability_Warrior_BattleShout";
    local hasBS = false;
    local inCombat = false;

    local t = UIParent:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetWidth(60)
    t:SetHeight(60)
    t:SetTexture(BSA_Texture)

    local t2 = UIParent:CreateFontString(nil,"OVERLAY","GameTooltipText")
    local textTimeTillDeath = UIParent:CreateFontString(nil,"OVERLAY","GameTooltipText")
    textTimeTillDeath:SetFont("Fonts\\FRIZQT__.TTF", 120, "OUTLINE, MONOCHROME")
    textTimeTillDeath:SetPoint("TOPLEFT", 1040, -545)

    local ONY = "Onyxia's Lair";
    local MC = "Molten Core";
    local BWL = "Blackwing Lair";
    local ZG = "Zul'Gurub";
    local AQ20 = "Ruins of Ahn'Qiraj";
    local AQ40 = "Temple of Ahn'Qiraj";
    local Naxx = "Naxxramas";
    local BB = "Stranglethorn Vale";
    local BS = "Burning Steppes";

    local armorValues = {};
    armorValues[ONY] = {};
    armorValues[ONY]["Onyxia"] = 4211;

    armorValues[AQ20] = {};
    armorValues[AQ20]['Ayamiss the Hunter'] = 4211;
    armorValues[AQ20]['Buru the Gorger'] = 3402;
    armorValues[AQ20]["General Rajaxx"] = 4211;
    armorValues[AQ20]["Kurinnaxx"] = 4211;
    armorValues[AQ20]["Moam"] = 4113;
    armorValues[AQ20]["Ossirian the Unscarred"] = 4211;
    
    armorValues[AQ40] = {};
    armorValues[AQ40]["The Prophet Skeram"] = 3402;
    armorValues[AQ40]["Lord Kri"] = 4211;
    armorValues[AQ40]["Princess Yauj"] = 4211;
    armorValues[AQ40]["Vem"] = 4211;
    armorValues[AQ40]["Battleguard Sartura"] = 4211;
    armorValues[AQ40]["Fankriss the Unyielding"] = 4211;
    armorValues[AQ40]["Viscidus"] = 4211;
    armorValues[AQ40]["Princess Huhuran"] = 4211;
    armorValues[AQ40]["Emperor Vek'lor"] = 3833;
    armorValues[AQ40]["Emperor Vek'nilash"] = 4211;
    armorValues[AQ40]["Ouro"] = 4211;
    armorValues[AQ40]["Eye of C'Thun"] = 4211;
    armorValues[AQ40]["C'Thun"] = 4211;
        -- BWL
    armorValues[BWL] = {};
    armorValues[BWL]["Razorgore the Untamed"] = 4211;
    armorValues[BWL]["Vaelastrasz the Corrupt"] = 4211;
    armorValues[BWL]["Chromaggus"] = 4211;
    armorValues[BWL]["Ebonroc"] = 4211;
    armorValues[BWL]["Firemaw"] = 4211;
    armorValues[BWL]["Flamegor"] = 4211;
    armorValues[BWL]["Nefarian"] = 4211;
    armorValues[BWL]["Broodlord Lashlayer"] = 4211;

    armorValues[MC] = {};
    armorValues[MC]["Baron Geddon"] = 4211;
    armorValues[MC]["Garr"] = 4211;
    armorValues[MC]["Gehennas"] = 3402;
    armorValues[MC]["Golemagg the Incinerator"] = 4211;
    armorValues[MC]["Lucifron"] = 3402;
    armorValues[MC]["Magmadar"] = 4211;
    armorValues[MC]["Majordomo Executus"] = 4211;
    armorValues[MC]["Ragnaros"] = 4211;
    armorValues[MC]["Shazzrah"] = 3402;
    armorValues[MC]["Sulfuron Harbinger"] = 4786;

    armorValues[Naxx] = {};
    armorValues[Naxx]["Anub'Rekhan"] = 4211;
    armorValues[Naxx]["Gluth"] = 4211;
    armorValues[Naxx]["Gothik the Harvester"] = 3402;
    armorValues[Naxx]["Grand Widow Faerlina"] = 3850;
    armorValues[Naxx]["Grobbulus"] = 4211;
    armorValues[Naxx]["Heigan the Unclean"] = 4211;
    armorValues[Naxx]["Highlord Mograine"] = 4211;
    armorValues[Naxx]["Instructor Razuvious"] = 4211;
    armorValues[Naxx]["Kel'Thuzad"] = 3402;
    armorValues[Naxx]["Lady Blaumeux"] = 4211;
    armorValues[Naxx]["Loatheb"] = 4611;
    armorValues[Naxx]["Maexxna"] = 4211;
    armorValues[Naxx]["Noth the Plaguebringer"] = 3850;
    armorValues[Naxx]["Patchwerk"] = 4611;
    armorValues[Naxx]["Sapphiron"] = 4211;
    armorValues[Naxx]["Sir Zeliek"] = 4211;
    armorValues[Naxx]["Stalagg"] = 4211;
    armorValues[Naxx]["Feugen"] = 4211;
    armorValues[Naxx]["Thaddius"] = 4611;
    armorValues[Naxx]["Thane Korth'azz"] = 4211;

        --Monsters in Dungeons
        --Lord Skwol	4061,
        --Prince Thunderaan	4213,
        --Atiesh	3850,
        --Gyth	4061,
        --Lord Valthalak	3400,

        -- World Boss
        --armorValues[Moonglade]["Omen"] = 4186;
        --"Azuregos" = 4211,
        --"Dark Reaver of Karazhan" = 4285,
        --"Emeriss" = 4211,
        --"Lethon" = 4211,
        --"Lord Kazzak" = 4211,
        --"Nerubian Overseer" = 3761,
        --"Taerar" = 4211,
        --"Ysondre" = 4211,
    -- Zul'Gurub
    armorValues[ZG] = {};
    armorValues[ZG]["Bloodlord Mandokir"] = 4211;
    armorValues[ZG]["Hakkar"] = 3402;
    armorValues[ZG]["Hazza'rah"] = 3402;
    armorValues[ZG]["High Priest Thekal"] = 3402;
    armorValues[ZG]["High Priest Thekal"] = 3850;
    armorValues[ZG]["High Priest Venoxis"] = 3402;
    armorValues[ZG]["High Priestess Arlokk"] = 3402;
    armorValues[ZG]["High Priestess Jeklik"] = 3402;
    armorValues[ZG]["High Priestess Mar'li"] = 3402;
    armorValues[ZG]["Jin'do the Hexxer"] = 3402;

    armorValues[BB] = {};
    armorValues[BB]["Bloodsail Mage"] = 3402;

    armorValues[BS] = {};
    armorValues[BS]["Expert Training Dummy"] = 3402;
    -- Globals Section
    local ONUPDATE_INTERVAL = 1.0; -- How often the OnUpdate code will run (in seconds)
    local timeSinceLastUpdate = 0;
    local combatStart = GetTime();
    function onUpdate(sinceLastUpdate)
        --if inCombat then 
            timeSinceLastUpdate = GetTime();
            if UnitIsEnemy("player","target") or UnitReaction("player","target") == 4 then
                local targetName = UnitName("target");
                local realZone = GetRealZoneText();
                local subZone  = GetSubZoneText();
                if (armorValues[realZone]) then
                    local armorValue = armorValues[realZone][targetName];
                    if armorValue then
                        textTimeTillDeath:SetText("Armor: "..armorValue);
                    else
                        textTimeTillDeath:SetText("Armor: undef");
                    end
                else
                    textTimeTillDeath:SetText("");
                end
            else
                textTimeTillDeath:SetText("");
            end
        --else
            --textTimeTillDeath:SetText("Armor: 0");
        --end
    end
    EliteWarrior.BSA:SetScript("OnUpdate", function(self) onUpdate(timeSinceLastUpdate); end);

    
    -- When the frame is shown, reset the update timer
    EliteWarrior.BSA:SetScript("OnShow", function(self)
        timeSinceLastUpdate = 0
    end)

    local function BSA_Show()
        if inCombat then
            t:SetPoint("TOPLEFT", 800, -500)
            textTimeTillDeath:SetPoint("TOPLEFT", 840, -545)
        end
    end
    
    local function BSA_Hide()
        t:SetPoint("TOPLEFT", -100, 100)
        --textTimeTillDeath:SetPoint("TOPLEFT", -100, 100)
        textTimeTillDeath:SetText("");
    end
    
    EliteWarrior.BSA:SetScript("OnEvent", function() 
        if event == "PLAYER_REGEN_DISABLED" then
            combatStart = GetTime();
            inCombat = true;
            BSA_Show();
        elseif event == "PLAYER_REGEN_ENABLED" then
            inCombat = false;
            combatStart = GetTime();
            BSA_Hide();
        elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
            if arg1 == "You gain Battle Shout." then
                hasBS = true;
                BSA_Hide();
            end
        elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
            if arg1 == "Battle Shout fades from you." then
                hasBS = false;
                BSA_Show();
            end
        elseif event == "PLAYER_LOGIN" then
            BSA_Hide();
    
            for n = 1, 40 do
                local texture = UnitBuff("player", n);
                if texture and texture == BSA_Texture then
                    hasBS = true;
                end
            end
        elseif event == "PLAYER_DEAD" then
            inCombat = false;
            hasBS = false;
            BSA_Hide();
        end
    end);
    EliteWarrior.BSA:RegisterEvent("UNIT_AURA")
    EliteWarrior.BSA:RegisterEvent("PLAYER_REGEN_ENABLED");
    EliteWarrior.BSA:RegisterEvent("PLAYER_REGEN_DISABLED");
    EliteWarrior.BSA:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
    --Sunder
    EliteWarrior.BSA:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
    EliteWarrior.BSA:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
    EliteWarrior.BSA:RegisterEvent("PLAYER_LOGIN");
    EliteWarrior.BSA:RegisterEvent("PLAYER_DEAD");
    
end