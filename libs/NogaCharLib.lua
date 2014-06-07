-- NogaCharLib v0.3 @ APIVersion 8
--      by Nogamara on EU-Lightspire
--         armagonlive at googlemail dot com
--         https://armagon.wordpress.com
--      placed in the public domain
--
-- How to use:
--      - place into YourAddon/Libs (or wherever you want)
--      - add this to toc.xml:
--        <Script Name="Libs/NogaCharLib.lua"/>
--      - add this to your addon:
--        local NogaCharLib = _G["NogaCharLib"]
--        local currency = NogaCharLib:GetCurrency()
--        local base = NogaCharLib:GetBaseStats()
--        local misc = NogaCharLib:GetMiscStats()
--        local all = NogaCharLib:GetAll()
require "GameLib"
require "Money"

local NogaCharLib = {
	gameDefs = {
		-- GameLib.GetPlayerUnit:GetFaction()
		mappingFactions = {
			[166] = "Dominion",
			[167] = "Exile",
		},
		-- GameLib.GetPlayerUnit:GetGender()
		mappingGenders = {
			[0] = "Male",
			[1] = "Female",
		},
		-- GameLib.CodeEnumClass.XXX
		codeEnumClass = {
			[1] = "Warrior",
			[2] = "Engineer",
			[3] = "Esper",
			[4] = "Medic",
			[5] = "Stalker",
			[7] = "Spellslinger",
		},
		-- GameLib.CodeEnumRace.XXX
		codeEnumRace = {
			[1] = "Human",
			[3] = "Granok",
			[4] = "Aurin",
			[5] = "Draken",
			[12] = "Mechari",
			[13] = "Chua",
			[16] = "Mordesh",
		},
		-- GameLib.CodeEnumZonePvpRules.XXX
		codeEnumZonePvpRules = {
			[0] = "None",
			[1] = "ExileStronghold",
			[2] = "DominionStronghold",
			[3] = "Sanctuary",
			[4] = "Pvp",
			[5] = "ExilePVPStronghold",
			[6] = "DominionPVPStronghold",
		},
		-- GameLib.CodeEnumItemSlots.XXX
		codeEnumItemSlots = {
			[1] = "Chest",
			[2] = "Legs",
			[3] = "Head",
			[4] = "Shoulder",
			[5] = "Feet",
			[6] = "Hands",
			[7] = "Tool",
			[20] = "Weapon",
			[43] = "Shields",
			[46] = "Gadget",
			[57] = "Attachment",
			[58] = "System",
			[59] = "Augment",
			[60] = "Implant",
		},
		-- GameLib.CodeEnumPetStance.XXX
		codeEnumPetStance = {
			[0] = "Assist",
			[1] = "Stay",
			[2] = "Passive",
			[3] = "Defensive",
			[4] = "Aggressive",
		}
	},
	fooDefs = {
		baseCallables = {
			GetClassId			= "n",
			--GetClassString
			GetGender			= "n",
			--GetGenderString
			GetFaction			= "n",
			--GetFactionString
			GetGuildName		= "s",
			GetGuildType		= "n",
			GetId				= "n",
			GetLevel			= "n",
			GetLevelString		= "s",
			GetName				= "s",
			GetPlayerPathType	= "n",
			GetRaceId			= "n",
			--GetRaceString
			GetRank				= "n",
			GetType				= "n",
			GetTitle			= "s",
			GetTitleOrName		= "s",
		},
		miscCallables = {
			GetAbsorptionMax		= "n",
			GetAbsorptionValue		= "n",
			GetAffiliationName		= "s",
			GetAssaultAndSupportPowerSoftcap	= "n",
			GetAssaultPower			= "n",
			GetBaseLifesteal		= "n",
			GetCooldownReductionModifier		= "n",
			GetCritChance			= "n",
			GetCritSeverity			= "n",
			GetDeflectChance		= "n",
			GetDeflectCritChance	= "n",
			GetHealth				= "n",
			GetIgnoreArmorBase		= "n",
			GetIgnoreShieldBase		= "n",
			GetInterruptArmorMax	= "n",
			GetInterruptArmorValue	= "n",
			GetMagicMitigation		= "n",
			GetMana					= "n",
			GetManaCostModifier		= "n",
			GetManaRegenInCombat	= "n",
			GetManaRegenNonCombat	= "n",
			GetMaxHealth			= "n",
			GetMaxMana				= "n",
			GetMaxResource			= "n",
			GetPhysicalMitigation	= "n",
			GetPvPDefensePercent	= "n",
			GetPvPDefenseRating		= "n",
			GetPvPOffensePercent	= "n",
			GetPvPOffenseRating		= "n",
			GetResource				= "n",
			GetResourceConversions	= "n",
			GetShieldCapacity		= "n",
			GetShieldCapacityMax	= "n",
			GetShieldRebootTime		= "n",
			GetShieldRegenPct		= "n",
			GetShieldTickTime		= "n",
			GetSpellMechanicId		= "n",
			GetSpellMechanicPercentage	= "n",
			GetStrikethroughChance	= "n",
			GetSupportPower			= "n",
		},
	},
}

function NogaCharLib:GetCurrency()
	local currency = {}
	currency.Credits = {}
	
	local credits = GameLib.GetPlayerCurrency(Money.CodeEnumCurrencyType.Credits):GetAmount() -- 
	currency.BaseCredits = credits
	
	currency.Credits.Copper = credits % 100
	credits = (credits - currency.Credits.Copper) / 100
	currency.Credits.Silver = credits >= 100 and (credits % 100) or credits
	credits = (credits - currency.Credits.Silver) / 100
	currency.Credits.Gold = credits >= 100 and (credits % 100) or credits
	credits = (credits - currency.Credits.Gold) / 100
	currency.Credits.Plat = credits >= 100 and (credits % 100) or credits
	
	currency.ElderGems = GameLib.GetPlayerCurrency(Money.CodeEnumCurrencyType.ElderGems):GetAmount()
	currency.Prestige = GameLib.GetPlayerCurrency(Money.CodeEnumCurrencyType.Prestige):GetAmount()
	currency.Renown = GameLib.GetPlayerCurrency(Money.CodeEnumCurrencyType.Renown):GetAmount()
	currency.CraftingVouchers = GameLib.GetPlayerCurrency(Money.CodeEnumCurrencyType.CraftingVouchers):GetAmount()
	currency.GroupCurrency = GameLib.GetPlayerCurrency(Money.CodeEnumCurrencyType.GroupCurrency):GetAmount()
	
	return currency
end

function NogaCharLib:GetBaseStats(unit)
	local pUnit = unit and unit or GameLib.GetPlayerUnit()
	local mt = getmetatable(pUnit)
	local stats = {}
	
	for func, type in pairs(NogaCharLib.fooDefs.baseCallables) do
		if func then
			stats[func:gsub("^Get", "")] = mt[func](pUnit)
		end
	end
	
	stats.ClassString	= stats.ClassId and NogaCharLib.gameDefs.codeEnumClass[stats.ClassId] or ""
	stats.RaceString		= stats.RaceId and NogaCharLib.gameDefs.codeEnumRace[stats.RaceId] or ""
	stats.FactionString	= stats.Faction and NogaCharLib.gameDefs.mappingFactions[stats.Faction] or ""
	stats.GenderString	= stats.Gender and NogaCharLib.gameDefs.mappingGenders[stats.Gender] or ""
	stats.Realm			= GameLib.GetRealmName()
	stats.GearScore		= GameLib.GetGearScore()
	
	return stats
end

function NogaCharLib:GetMiscStats(unit)
	local pUnit = unit and unit or GameLib.GetPlayerUnit()
	local mt = getmetatable(pUnit)
	local stats = {}
	
	for func, type in pairs(NogaCharLib.fooDefs.miscCallables) do
		if func then
			stats[func:gsub("^Get", "")] = mt[func](pUnit)
		end
	end
	
	return stats
end

function NogaCharLib:GetAll(unit)
	local data = {}
	data.Base = NogaCharLib:GetBaseStats(unit)
	data.Misc = NogaCharLib:GetMiscStats(unit)
	data.Currency = NogaCharLib:GetCurrency()
	
	return data
end

Apollo.RegisterPackage(NogaCharLib, "NogaCharLib", 2, {})
-- NogaCharLib = nil