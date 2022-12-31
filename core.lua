EliteWarrior = {};

BSA_Texture = "Interface\\Icons\\Ability_Warrior_BattleShout";
BigKings_Texture = "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings";
BigMight_Texture = "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings";
BigMight_Texture = "Interface\\Icons\\Ability_Racial_BloodRage";
ShadowProt_Texture = "Interface\\Icons\\Spell_Holy_PrayerofShadowProtection";
Fortitude_Texture = "Interface\\Icons\\Spell_Holy_PrayerOfFortitude";
MarkOfWild_Texture = "Interface\\Icons\\Spell_Nature_Regeneration";
BigLight_Texture = "Interface\\Icons\\Spell_Holy_GreaterBlessingofLight";
Spirit_Texture = "Interface\\Icons\\Spell_Holy_PrayerofSpirit";

function getBuffs() 
  local buffs, i = { }, 1;
  local buff = UnitBuff("player", i);
  while buff do
    buffs[buff] = 1;
    i = i + 1;
    buff = UnitBuff("player", i);
    --SendChatMessage(""..buff, "emote");
  end;
  EliteWarrior.buffs = buffs or {};
end;

function declareBuffs()
  getBuffs();
  local buffs = EliteWarrior.buffs;
  if table.getn(buffs) < 1 then
    buffs = "You have no buffs";
  else
    buffs[1] = "You're buffed with: "..buffs[1];
    buffs = table.concat(buffs, ", ");
  end;
  --SendChatMessage(buffs, "emote");
end;

function getGroupNumber()
    
end;

--button:RegisterEvent("UNIT_INVENTORY_CHANGED");
--button:SetScript("OnEvent", function()
    --print(event);
    --if event == "UNIT_INVENTORY_CHANGED" then
        --print("INVENTORY CHANGED");
        --button:Enable()
        --button:Show();
        --QTYItem(ItemAssociated)
    --end
--end);



getBuffs();
