EliteWarrior.Consumes = CreateFrame("Frame");
EliteWarrior.Consumes:RegisterEvent("UNIT_AURA")

local gAgility_Texture = "Interface\\Icons\\inv_potion_94";
local gAgility_Buff = "Interface\\Icons\\inv_potion_93";
local Mongoose_Texture = "Interface\\Icons\\INV_Potion_32";
local Stoneshield_Texture = "Interface\\Icons\\INV_Potion_69";
local JujuPower_Texture = "Interface\\Icons\\INV_Misc_MonsterScales_11";
local JujuMight_Texture = "Interface\\Icons\\INV_Misc_MonsterScales_07";
local WinterfallFirewater_Texture = "Interface\\Icons\\INV_Potion_92";
local RumseyRumBlackLabel_Texture = "Interface\\Icons\\INV_Drink_04";
local Fortitude_Texture = "Interface\\Icons\\INV_Potion_43";
local Fortitude_Buff = "Interface\\Icons\\INV_Potion_44";
local SmokedDesertDumplings_Texture = "Interface\\Icons\\INV_Misc_Food_64";
local wellFed_Buff = "Interface\\Icons\\spell_misc_food";
local GFirePP_Texture = "Interface\\Icons\\INV_Potion_24";
local GFirePP_Buff = "Interface\\Icons\\spell_fire_firearmor";
local GShadowPP_Texture = "Interface\\Icons\\INV_Potion_23";
local GShadowPP_Buff = "Interface\\Icons\\spell_shadow_ragingscream";
local GNaturePP_Texture = "Interface\\Icons\\INV_Potion_22";
local GNaturePP_Buff = "Interface\\Icons\\spell_nature_spiritarmor";
local GArcanePP_Texture = "Interface\\Icons\\INV_Potion_83";
local GFrostPP_Texture = "Interface\\Icons\\INV_Potion_20";
local LIP_Texture = "Interface\\Icons\\INV_Potion_62";
local LIP_Buff = "Interface\\Icons\\spell_holy_divineintervention";
local OilOfImmolation_Texture = "Interface\\Icons\\INV_Potion_11";
local OilOfImmolation_Buff = "Interface\\Icons\\spell_fire_immolation";
local MightyRage_Texture = "Interface\\Icons\\INV_Potion_41";
local MightyRage_Buff = "Interface\\Icons\\ability_warrior_innerrage";
local EleSharpStone_Texture = "Interface\\Icons\\INV_Stone_02";
local Giants_Texture = "Interface\\Icons\\INV_Potion_61";
local SuperiorDefense_Texture = "Interface\\Icons\\INV_Potion_66";
local SuperiorDefense_Buff = "Interface\\Icons\\INV_Potion_86";
local WoolFirstAid_Texture = "Interface\\Icons\\inv_misc_bandage_14";
local HeavyRuneclothBandage_Texture = "Interface\\Icons\\inv_misc_bandage_12";
local firstAid_Buff = "Interface\\Icons\\spell_holy_heal"; -- looks like renew

--Test Texture
local BloodRage_Texture = "Interface\\Icons\\Ability_Racial_BloodRage";

local ChatFrameBackground = "Interface\\ChatFrame\\ChatFrameBackground";

local consumeBuffList = {};
consumeBuffList['Elixir of the Mongoose'] = Mongoose_Texture;

local buffs = EliteWarrior.buffs;

--UNIT_INVENTORY_CHANGED fires when (among other things) the player's temporary enchants, and thus the return values from this function, change.
local hasMHEnchant,
      MHExpiration,
      MHEnchantID,
      hasOHEnchant,
      OHExpiration,
      OHEnchantID  = GetWeaponEnchantInfo();
DEFAULT_CHAT_FRAME:AddMessage(hasMHEnchant);
DEFAULT_CHAT_FRAME:AddMessage(MHExpiration);
DEFAULT_CHAT_FRAME:AddMessage(MHEnchantID);
DEFAULT_CHAT_FRAME:AddMessage(hasOHEnchant);
DEFAULT_CHAT_FRAME:AddMessage(OHExpiration);
DEFAULT_CHAT_FRAME:AddMessage(OHEnchantID);

function useItem(itemName, button)
    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local name = GetContainerItemLink(bag,slot);
            if name and string.find(name,itemName) then
                    UseContainerItem(bag, slot, 1)
                    DEFAULT_CHAT_FRAME:AddMessage(itemName);
                    
                    --if (button) then -- and hasCooldown
                    --    local link = GetContainerItemLink(bag,slot);
                        --local itemID = ItemLinkToID(link);
                        --local itemCD = GetItemCooldown(itemID)
                    --    local itemStart, itemCD = 763120.531, 6 or GetContainerItemCooldown(bag,slot);
                    --    DEFAULT_CHAT_FRAME:AddMessage("CD:"..itemCD);

                        --button:SetCooldown(GetTime(), itemCD)
                    --end;
                return;
            end;
        end;
    end
end
function findBagSlot(itemName)
    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local name = GetContainerItemLink(bag,slot);
            if name and string.find(name,itemName) then
                return bag, slot;
            end;
        end;
    end
end

function ItemLinkToName(link)
	if ( link ) then
   	    return gsub(link,"^.*%[(.*)%].*$","%1");
        --(itemLink, "|h%[(.*)%]");
	end
end
function ItemLinkToID(link)
	if ( link ) then
        local _, _, Id = string.find(link, "|?c?f?f?%x*|?H?[^:]*:?(%d+)")
        return Id;
	end
end
function FindSpell(spell, rank)
	local i = 1;
	local booktype = { "spell", "pet", };
	local s,r;
	local ys, yr;
	for k, book in booktype do
		while spell do
		s, r = GetSpellName(i,book);
		if ( not s ) then
			i = 1;
			break;
		end
		if ( string.lower(s) == string.lower(spell)) then ys=true; end
		if ( (r == rank) or (r and rank and string.lower(r) == string.lower(rank))) then yr=true; end
		if ( rank=='' and ys and (not GetSpellName(i+1, book) or string.lower(GetSpellName(i+1, book)) ~= string.lower(spell) )) then
			yr = true; -- use highest spell rank if omitted
		end
		if ( ys and yr ) then
			return i,book;
		end
		i=i+1;
		ys = nil;
		yr = nil;
		end
	end
	return;
end
local updateCoolDownTimerRun = {};
function updateCoolDownTimer(ItemAssociated, coolDownText, uniqueIdentifier)
    local updateTimer = updateCoolDownTimerRun[uniqueIdentifier];
    if (not updateTimer or updateTimer < GetTime()-1) then -- run only once a second
        updateCoolDownTimerRun[uniqueIdentifier] = GetTime();
        local bag, slot = findBagSlot(ItemAssociated);
        local itemStart, itemCD = GetContainerItemCooldown(bag,slot);
        if (itemStart) then
            local endTime = itemStart+itemCD;
            local timeRemaining = endTime-GetTime();
            if (timeRemaining > 0) then
                if (timeRemaining > 60) then
                    coolDownText:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE, MONOCHROME")
                    coolDownText:SetText(string.format("%.0f",timeRemaining/60).."m");
                elseif timeRemaining > 10 then
                    coolDownText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE, MONOCHROME")
                    coolDownText:SetText(string.format("%.0f",timeRemaining));
                elseif timeRemaining > 0 then
                    coolDownText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE, MONOCHROME")
                    coolDownText:SetText(string.format("%.1f",timeRemaining));
                    updateCoolDownTimerRun[uniqueIdentifier] = GetTime()-.9;
                end;
            else
                coolDownText:SetText("");
            end
        end;
    end
end

local itemQTYs = {};
local ONUPDATE_INTERVAL = 1.0; -- How often the OnUpdate code will run (in seconds)
local timeSinceLastUpdate = GetTime();
function QTYItem(itemName)
    --DEFAULT_CHAT_FRAME:AddMessage(itemName);
    itemQTYs = {}; -- Empty Start Over
    timeSinceLastUpdate = GetTime();
    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local itemLink = GetContainerItemLink(bag,slot);
            local _, slotQty = GetContainerItemInfo(bag,slot);
            if itemLink then
                local name = ItemLinkToName(itemLink)
                itemQTYs[name] = (itemQTYs[name] or 0)+slotQty;
            end
        end;
    end;
    return itemQTYs[itemName];
end
local frameXA = math.floor(GetScreenWidth()*.93)
local frameXB = math.floor(GetScreenWidth()*.945)
local frameXC = math.floor(GetScreenWidth()*.96)
local frameYA = math.floor(GetScreenHeight()*.37);
local frameYB = math.floor(GetScreenHeight()*.37);
local frameYC = math.floor(GetScreenHeight()*.37);

function createButtonA(Texture, ItemAssociated, BuffToLookFor)
    createButton(Texture, ItemAssociated, BuffToLookFor, frameXA, frameYA)
    frameYA = frameYA+17.25;
end;
function createButtonB(Texture, ItemAssociated, BuffToLookFor)
    createButton(Texture, ItemAssociated, BuffToLookFor, frameXB, frameYB)
    frameYB = frameYB+17.25;
end;
function createButtonC(Texture, ItemAssociated, BuffToLookFor)
    createButton(Texture, ItemAssociated, BuffToLookFor, frameXC, frameYC)
    frameYC = frameYC+17.25;
end;
function createButtonSpaceC()
    frameYC = frameYC+17.25;
end
function createButtonSpaceB()
    frameYB = frameYB+17.25;
end
function createButtonSpaceA()
    frameYA = frameYA+17.25;
end
function createButton(Texture, ItemAssociated, BuffToLookFor, btnX, btnY)
    local uniqueIdentifier = Texture..ItemAssociated;
    local myFrame = CreateFrame("Frame", nil, mainframe)
    local button = CreateFrame("Button", nil, myFrame)
    --local myCooldown = CreateFrame("Cooldown", "myCooldown", button, "CooldownFrameTemplate")
    local hoverText = button:CreateFontString(nil,"OVERLAY","GameTooltipText")
    hoverText:SetShadowOffset(1,-2);
    hoverText:SetFont("Fonts\\FRIZQT__.TTF", 6, "OUTLINE, MONOCHROME")
    local QTYText = button:CreateFontString(nil,"OVERLAY","GameTooltipText")
    QTYText:SetShadowOffset(-1,1);
    QTYText:SetPoint("TOPLEFT", mainframe, "TOPLEFT", btnX+3, (btnY*-1)-8);
    QTYText:SetTextColor(.2, 1, 1, 1);
    QTYText:SetFont("Fonts\\FRIZQT__.TTF", 6, "OUTLINE, MONOCHROME")
    QTYText:SetJustifyH("RIGHT");
    QTYText:SetWidth(12);
	button:SetPoint("TOPLEFT", mainframe, "TOPLEFT", btnX, btnY*-1)
	button:SetWidth(16)
	button:SetHeight(16)
    local coolDownText = button:CreateFontString(nil,"OVERLAY","GameTooltipText")
    coolDownText:SetShadowOffset(-1,1);
    coolDownText:SetPoint("TOPLEFT", mainframe, "TOPLEFT", btnX, (btnY*-1)-2);

	local ntex = button:CreateTexture()
	ntex:SetTexture(Texture)
	ntex:SetTexCoord(0, 1, 0, 1)
	ntex:SetAllPoints()	
	button:SetNormalTexture(ntex)

	local htex = button:CreateTexture()
	htex:SetTexture(Texture)
	htex:SetTexCoord(0, 1, 0, 1)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)

	local ptex = button:CreateTexture()
	ptex:SetTexture(Texture)
	ptex:SetTexCoord(0, 1, 0, 1)
	ptex:SetAllPoints()
	button:SetPushedTexture(ptex)
    button:SetMovable(true)
    button:SetToplevel(1)
    button:SetClampedToScreen(1)
    button:RegisterForDrag("LeftButton")
    --button:SetPoint("CENTER")

    button:SetScript("OnDragStart", function(self)
        if IsShiftKeyDown() then
            button:StartMoving()
        end
    end)
    button:SetScript("OnDragStop", function(self)
        button:StopMovingOrSizing()
        local point, relativeTo, relativePoint, xOfs, yOfs = button:GetPoint()
        QTYText:SetPoint("TOPLEFT", mainframe, "TOPLEFT", xOfs+3, yOfs-8);
    end)
    button:SetScript("OnClick", function()
        useItem(ItemAssociated, button)
    end)
    button:SetScript("OnEnter", function(self)
        hoverText:SetText(ItemAssociated);
        local x, y = GetCursorPosition();
        hoverText:SetPoint("BOTTOMLEFT", mainframe, x-50, y+20);
        local bag, slot = findBagSlot(ItemAssociated);
        --GameTooltip:SetSpell(46, BOOKTYPE_SPELL)
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        hasCooldown, repairCost = GameTooltip:SetBagItem(bag, slot);
        GameTooltip:Show();
        --id, book = FindSpell("Attack","");
        --https://wowwiki-archive.fandom.com/wiki/API_GameTooltip_SetBagItem
        --hasCooldown, repairCost = GameTooltip:SetBagItem(bag, slot);
        --GameTooltip:SetSpell(id, book);
        --https://wowwiki-archive.fandom.com/wiki/API_Cooldown_SetCooldown
        if (hasCooldown) then
            local link = GetContainerItemLink(bag,slot);
            local itemID = ItemLinkToID(link);
            local itemCD = GetItemCooldown(itemID)
            button:SetCooldown(GetTime(), itemCD)
        end;
    end)
    button:SetScript("OnUpdate", function(self)
        updateCoolDownTimer(ItemAssociated, coolDownText, uniqueIdentifier);
    end)
    button:SetScript("OnLeave", function(self)
        hoverText:SetText("");
        GameTooltip:FadeOut()
    end)
    button:RegisterEvent("BAG_UPDATE");
    button:RegisterEvent("ITEM_LOCK_CHANGED");
    button:RegisterEvent("PLAYER_LOGIN");
    button:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
    button:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
    button:SetScript("OnEvent", function()
        if event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
            itemCount = QTYItem(ItemAssociated);
            ShowHideItemQTY(itemCount, button, QTYText)
            if (itemCount) then
                if checkForBuff(Texture, BuffToLookFor) then
                    button:Hide();
                end
            end
        end
        if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
            -- No way to track Jujus of power/might so temporary solution
            --print(arg1);
            if (ItemAssociated and string.find(ItemAssociated,"juju")) then
            else
                if checkForBuff(Texture, BuffToLookFor) then
                    button:Hide();
                end
            end

        end
        if event == "PLAYER_LOGIN" then
            itemCount = QTYItem(ItemAssociated);
            --print(ItemAssociated..": "..itemCount)
            if (itemCount ~= nil) then
                button:Show();
            end
        end
        if event == "BAG_UPDATE" or event == "ITEM_LOCK_CHANGED" then
            itemCount = QTYItem(ItemAssociated);
            ShowHideItemQTY(itemCount, button, QTYText)
        end
        
    end);
    --SetResizable(1)
    --https://wowpedia.fandom.com/wiki/Making_resizable_frames
    --SetMovable(isMovable) - Set whether the frame can be moved.
    --https://wowpedia.fandom.com/wiki/Making_draggable_frames
end
function ShowHideItemQTY(itemCount, button, QTYText)
    if (itemCount == nil) then
        button:Disable()
        button:Hide()
    else
        --print(ItemAssociated..": "..itemCount)
        QTYText:SetText(itemCount);
        button:Enable()
        button:Show()
    end
end
function checkForBuff(Texture, BuffToLookFor)
    local i = 1;
    local buff = UnitBuff("player", i);
    while buff do
        if (buff == nil) then
            break;
        end
        if (buff == Texture) then
            --print("Texture T:"..Texture.." B:"..buff)
            return true;
        end
        --print(buff);
        if (BuffToLookFor) then
            if (type(BuffToLookFor) == 'string') then
                if (BuffToLookFor == buff) then
                    --print("String B:"..BuffToLookFor.." B:"..buff)
                    return true;
                end
            else
                if (type(BuffToLookFor) == 'table') then
                    for buffI in BuffToLookFor do
                        if BuffToLookFor[buffI] == buff then
                            --print("I: "..buffI.." L:"..BuffToLookFor[buffI].." C:"..buff)
                            return true;
                        end
                    end
                end
            end
        end
        i = i+1;
        buff = UnitBuff("player", i);
    end;
    return false;
end;

createButtonA(GFirePP_Texture, "Greater Fire Protection Potion", GFirePP_Buff);
createButtonA(GShadowPP_Texture, "Greater Shadow Protection Potion", GShadowPP_Buff);
createButtonA(GNaturePP_Texture, "Greater Nature Protection Potion", GNaturePP_Buff);
createButtonA(GArcanePP_Texture, "Greater Arcane Protection Potion");
createButtonA(GFrostPP_Texture, "Greater Frost Protection Potion");
createButtonSpaceA();
createButtonA(LIP_Texture, "Limited Invulnerability Potion", LIP_Buff);
createButtonA(OilOfImmolation_Texture, "Oil of Immolation", OilOfImmolation_Buff);
createButtonA(WoolFirstAid_Texture, "Wool Bandage", firstAid_Buff);
createButtonA(HeavyRuneclothBandage_Texture, "Wool Bandage", firstAid_Buff);

createButtonB(gAgility_Texture, "Elixir of Greater Agility", {Mongoose_Texture, gAgility_Buff});
createButtonB(Giants_Texture, "Elixir of Giants", JujuPower_Texture);
createButtonB(WinterfallFirewater_Texture, "Winterfall Firewater", JujuMight_Texture);
createButtonC(Mongoose_Texture, "Elixir of the Mongoose");
createButtonC(JujuPower_Texture, "Juju Power");
createButtonC(JujuMight_Texture, "Juju Might");
createButtonC(SmokedDesertDumplings_Texture, "Smoked Desert Dumplings", wellFed_Buff);
createButtonC(MightyRage_Texture, "Mighty Rage Potion", MightyRage_Buff);
createButtonC(EleSharpStone_Texture, "Elemental Sharpening Stone");
createButtonSpaceC();
createButtonC(Stoneshield_Texture, "Greater Stoneshield Potion");
createButtonC(RumseyRumBlackLabel_Texture, "Rumsey Rum Black Label");
createButtonC(Fortitude_Texture, "Elixir of Fortitude", Fortitude_Buff);
createButtonC(SuperiorDefense_Texture, "Elixir of Superior Defense", SuperiorDefense_Buff);
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------

EliteWarrior.Consumes:RegisterEvent("UNIT_AURA")
EliteWarrior.Consumes:RegisterEvent("PLAYER_REGEN_ENABLED");
EliteWarrior.Consumes:RegisterEvent("PLAYER_REGEN_DISABLED");
EliteWarrior.Consumes:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
EliteWarrior.Consumes:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
EliteWarrior.Consumes:RegisterEvent("PLAYER_DEAD");
