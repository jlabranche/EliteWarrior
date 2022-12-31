EliteWarrior.Consumes = CreateFrame("Frame");
EliteWarrior.Consumes:RegisterEvent("UNIT_AURA")

local BigKings_Texture = "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings";
local BigMight_Texture = "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings";
--EliteWarrior.Consumes:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
--local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player", 1);


getBuffs()

local inRaid = GetNumRaidMembers();
local inParty = GetNumPartyMembers();

local buffs = EliteWarrior.buffs;
if table.getn(buffs) < 1 then
  --SendChatMessage("You have no buffs", "emote");
else
  buffs[1] = "You're buffed with: "..buffs[1];
  buffs_txt = table.concat(buffs, ", ");
  SendChatMessage(buffs_txt, "emote");
end;


--[[
function EliteWarrior.Consumes:UNIT_AURA(...)
    -- magic
end



local Debug = function  (str, ...)
    if ... then str = str:format(...) end
    DEFAULT_CHAT_FRAME:AddMessage(("Addon: %s"):format(str));
end

Debug("My first Addon!!");


GameTooltip:HookScript("OnTooltipSetSpell", function(self)
    local name, id = self:GetSpell()
    if id then
        self:AddLine("    ")
        self:AddLine("ID: " .. tostring(id), 1, 1, 1)
    end
end)
--]]

