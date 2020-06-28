-- Template for creating simple custom ttt2 weapons --

-- Tell the server to send this file to clients when they join
-- SERVER and CLIENT are global variables which return true if the script is being executed if its being executed on the server or client
print("Loaded-----------------------------------------------------------")
if SERVER then
   -- Shares the lua file with the client if they don't have the addon
   AddCSLuaFile("weapon_ttt_template.lua")

   -- Shares the buy menu icon with the client if they don't have the addon
   --[[
      It's very important to create a globally unique name for this because the Gmod
      client will look for the given path locally to display it. So if there are two
      identical icon names the client may display the incorrect one
   --]]
   resource.AddFile("materials/VGUI/ttt/icon_myserver_ak47.vmt")
end

if CLIENT then
   -- Client viewpoint vals
   SWEP.PrintName          = "Template Weapon"
   SWEP.Slot               = 6 -- (See SWEP.Kind below)
   SWEP.ViewModelFOV       = 70
   SWEP.ViewModelFlip      = true
   SWEP.DrawCrossHair      = false -- Does the client draw its own crosshair over the default ones

   -- Client menu data
   SWEP.Icon = "<icon missing>" -- The filename of the icon shown in the buymenu
   -- The information shown in the buy menu
   SWEP.EquipMenuData      =
   {
      type = "Weapon",
      desc = "This is a template weapon"
   };
end

-- What weapon this is based upon (always use weapon_tttbase when creating a ttt/2 weapon)
SWEP.Base                  = "weapon_tttbase"



-- Primary fire vals
-- Note, you can also script secondary fire attributes which are for alt fire (SWEP.Secondary)
SWEP.Primary.Delay         = 0.01 -- Higher is slower
SWEP.Primary.Automatic     = true
SWEP.Primary.Damage        = 10
SWEP.Primary.Cone          = 0.05 -- Cone of accuracy
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.ClipSize      = 100 -- Maximum clip size
SWEP.Primary.DefaultClip   = 100 -- Starting clip size
SWEP.Primary.Sound         = Sound("Weapon_AK47.Single")
SWEP.Primary.NumShots      = 1 -- Number of shots fired at one time
SWEP.Primary.Recoil        = 1.5 -- Base recoil value

-- View model info
SWEP.HoldType              = "ar2"
SWEP.ViewModel             = "models/weapons/c_irifle.mdl" -- What the swep looks like to the user
SWEP.WorldModel            = "models/weapons/w_irifle.mdl" -- What the swep looks like to everyone else
SWEP.UseHands              = true -- Whether the swep will force the user to see the viewmodel's hands (prevents issues with custom models?)
 SWEP.Kind                 = WEAPON_EQUIP1 -- Kind specifies what weapon_ttt category it falls into
--[[
   (        0      1      2       3      4     5      6       7       8   ) +1 to get the eqip slot key
   (WEAPON_ MELEE, HEAVY, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2, ROLE)
--]]
SWEP.AutoSpawnable         = false -- Whether the swep will spawn upon map gen (override as false if EQUIP1/2)
SWEP.AmmoEnt               = "item_ammo_smg1_ttt" -- Which entity you pick up to fill your clips
SWEP.CanBuy                = {ROLE_TRAITOR} -- Which roles can purchase this swep (table)
SWEP.InLoadoutFor          = nil -- Which roles gain this weapon upon round start (table)
SWEP.LimitedStock          = true -- If true only one can be bought per round
SWEP.AllowDrop             = true -- Is the player able to drop the swep
SWEP.IsSilent              = false -- If true, the killed player will not scream upon death
SWEP.NoSights              = false -- If true, the swep has no ironsights capability (no Secondary fire if ironsights?)
SWEP.HeadshotMultiplier    = 50
SWEP.DeploySpeed           = 0.2 -- Lower the slower
SWEP.IronSightsPos         = Vector(-2, -5, 0) -- Moves the Viewmodel by this vector when using ironsights
SWEP.IronSightsAng         = Vector(-2, 0, 0) -- Rotates the Viewmodel by this angle when using ironsights


-- REDUNDANT SETTINGS (read them because they may still be appicable) --

-- DO NOT set SWEP.WeaponID. Only the standard TTT weapons can have it. Custom
-- SWEPs do not need it for anything.
--	SWEP.WeaponID = nil
