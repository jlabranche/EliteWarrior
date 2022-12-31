-- START OF ACE
EliteWarriorA = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0", "AceModuleCore-2.0", "FuBarPlugin-2.0", "AceComm-2.0", "AceHook-2.1")

local T = AceLibrary("Tablet-2.0")
local commPrefix = "EliteWarrior";
local VERSION = 1;
EliteWarriorA:SetCommPrefix(commPrefix)

function EliteWarriorA:OnClick()
	declareBuffs()
end
function EliteWarriorA:OnTooltipUpdate()
  T:SetHint("by Hobbit, v"..tostring(VERSION))
end

EliteWarriorA.defaultMinimapPosition = 200
EliteWarriorA.cannotDetachTooltip = true
EliteWarriorA.tooltipHidderWhenEmpty = false
EliteWarriorA.hasIcon = "Interface\\Icons\\Inv_Misc_Bomb_03"
EliteWarriorA:RegisterDB("EliteWarriorDB")
EliteWarriorA:RegisterDefaults('realm', {
	hs = {
		currentStandings = {},
		last_reset = 0,
		limit = 750,
    reset_day = 3
	}
})

function EliteWarriorA:OnEnable()
	self.OnMenuRequest = EliteWarrior_BuildMenu();
end
function EliteWarrior_BuildMenu()
	local options = {
		type = "group",
		desc = "EliteWarrior options",
		args = { },
	}

	local days = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };
	options.args["reset_day"] = {
		type = "text",
		name = "PvP Week Reset On",
		desc = "Day of week when new PvP week starts (10AM UTC)",
		get = function() return days[EliteWarriorA.db.realm.hs.reset_day+1] end,
		set = function(v)
			for k,nv in pairs(days) do
				if (v == nv) then EliteWarriorA.db.realm.hs.reset_day = k-1 end;
			end
		end,
		validate = days,
	}
	

	return options
end;

-- CHAT COMMANDS
function EliteWarriorA:equip(itemName)
  --SendChatMessage("equip: "..itemName, "emote");
  for bag = 0, 4, 1 do
      for slot = 1, GetContainerNumSlots(bag), 1 do
          local name = GetContainerItemLink(bag,slot);
          if name and string.find(name,itemName) then
              --SendChatMessage(name, "emote");
              UseContainerItem(bag, slot, 1)
              --DEFAULT_CHAT_FRAME:AddMessage("Missing "..name);
          end;
      end;
  end
end;

function EliteWarriorA:equipoh(itemName)
  --SendChatMessage("equipoh: "..itemName, "emote");
  for bag = 0, 4, 1 do
      for slot = 1, GetContainerNumSlots(bag), 1 do
          local name = GetContainerItemLink(bag,slot);
          if name and string.find(name,itemName) then
              --SendChatMessage(name, "emote");
              --UseContainerItem(bag, slot, 1)
              PickupContainerItem(bag, slot);
              PickupInventoryItem(17);
              --DEFAULT_CHAT_FRAME:AddMessage("Missing "..name);
          end;
      end;
  end
end;

local options = { 
	type='group',
	args = {
		equip = {
			type = 'text',
			name = 'Equips an item',
			desc = 'Equips an item',
			usage = 'item_name',
			get = false,
			set = function(equipName) EliteWarriorA:equip(equipName) end
		},
		equipoh = {
			type = 'text',
			name = 'Equips an item in the offhand',
			desc = 'Equips an item in the offhand',
			usage = 'item_name',
			get = false,
			set = function(equipOhName) EliteWarriorA:equipoh(equipOhName) end
		},
	}
}
EliteWarriorA:RegisterChatCommand({"/elitewarrior", "/ew"}, options)
-- END OF ACE