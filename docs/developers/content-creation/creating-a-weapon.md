# Creating a Weapon

When starting content creation for gmod, creating a basic weapon using the SWEP structure is one of the easiest things you can do.
For this guide I'll be using the Visual Studio Code with the glualint extension as referenced in the [Creating An Addon](../basics/creating-an-addon.md) section of these documents. Using those instructions for setting up the editor and project structure/management will make it easier for us to support you with any problems while coding.

## File Format

The most important thing you must get right about weapons (or addons in general) is the folder structure. If your structure is all wrong, them gmod won't recognise the files and your addon will break.

### Weapon Lua Script

Your weapon's lua file must be in this format:

* `<addon name>/gamemodes/terrortown/entities/weapons/weapon_ttt_/<weapon name>.lua`

### Icon Files

Your .vmt and .vtf icon files (what gets shown in the buy menu) will need to be stored in this format:

* `<addon name>/materials/vgui/ttt/<weapon name>_icon.vtf`
* `<addon name>/materials/vgui/ttt/<weapon name>_icon.vmt`

Documentation on how to create icons will be uploaded soon.

### Model Files

Model files for the SWEP will also need to be stored in the addon folder, unless you're using the default ones which come with source games. It's advised that even if you're using non-GMod models that you include them in the addon because not all users will own CS:S or Half life, etc.

* `<addon name>/materials/models/<model folder>/<model name>.vmt`
* `<addon name>/models/<model files>`

Documentation on how to create models will be uploaded soon.

GMod default weapon model paths are found [here](https://wiki.facepunch.com/gmod/Common_Weapon_Models).

### Sound Files

Custom sounds for your SWEP will need to be stored in this folder if you're not going to use the default sounds from GMod. This has the benefit that they're only loaded when you're using the ttt/2 gamemode.

* `<addon name>/gamemodes/terrortown/content/sound/`

!!! note
   Sounds types accepted are: .wav, .mp3 and .ogg.

GMod default sound paths are found [here](https://wiki.facepunch.com/gmod/Common_Sounds).

### Language files

It would be greatly appreciated if you included support for multiple languages into your addon so that it becomes more accessible for users. Extra accessiblilty will also help with getting your addon noticed and downloaded if you're planning on uploading it to the Workshop. When you want a string (e.g. the description in the buy menu) to be translated, you place in a language identifier instead. A language identifier is placed in each file as a variable name and the value of which is the translation.

Each language file will need to be stored in this format:

* `<addon name>/lua/lang/<language folder>/<lang file name>.lua`

!!! note
   The language identifier should be unique to prevent clashes with other addons' translations.

See the [Language Support](language-support.md) page for more information on this topic.

See the [Creating An Addon](../basics/creating-an-addon.md/#project-structure) page for more info on folder structure.

## General setup

### If SERVER Block

```lua
if SERVER then
   -- Shares the specified file with the client (if blank shares current file)
   AddCSLuaFile()

   -- Shares the buy menu icon with the client
   resource.AddFile("materials/vgui/ttt/blue_template_icon.vmt")
end
```

It's very important to create a globally unique name for this because the Gmod
client will look for the given path locally to display it. So if there are two
identical icon names the client may display the incorrect one.

### If CLIENT Block

```lua
if CLIENT then
   -- Client viewpoint vals
   SWEP.PrintName          = "Template Weapon"
   SWEP.ViewModelFOV       = 70 -- How much of the first person viewmodel is seen
   SWEP.ViewModelFlip      = true -- If true, the viewmodel is on the left
   SWEP.DrawCrossHair      = false -- Does the client draw its own crosshair over the default ones

   -- Client menu data
   SWEP.Icon = "vgui/ttt/blue_template_icon.vtf" -- The filename of the icon shown in the buymenu
   -- The information shown in the buy menu
   SWEP.EquipMenuData      =
   {
      type = "item_weapon",
      name = "weapon_template_name",
      desc = "weapon_tempalte_desc"
   }
end
```

The name and description values (language identifiers) are used in this format so as to allow for multi language support, see the [Language Files](#language-files) section for more info.

## Important SWEP values

```lua
-- What weapon this is based upon (always use weapon_tttbase when creating a ttt/2 weapon)
SWEP.Base                  = "weapon_tttbase"
```

The TTT2 gamemode has a file which describes the default values and methods. Any SWEP which specifies weapon_tttbase inherits the attributes and methods unless specified.

```lua
-- Primary fire vals
SWEP.Primary.Delay         = 0.001 -- Higher is slower
SWEP.Primary.Automatic     = true -- Is it automatic
SWEP.Primary.Damage        = 1 -- How much damage per shot
SWEP.Primary.Cone          = 0.5 -- Cone of accuracy
SWEP.Primary.Ammo          = "smg1" -- Which ttt ammo entity is picked up by this swep
SWEP.Primary.ClipSize      = 100 -- Maximum clip size
SWEP.Primary.DefaultClip   = 100 -- Starting clip size
SWEP.Primary.Sound         = Sound("Weapon_AK47.Single") -- Either a sound file from the default list or a custom one
SWEP.Primary.NumShots      = 1 -- Number of shots fired at one time (make into shotgun if increase conde val)
SWEP.Primary.Recoil        = 1.5 -- Recoil value (bigger = bigger)
```

!!! note
    All of these attributes can also be applied to SWEP.Secondary which is alt click (if you disable ironsights).

```lua
SWEP.HoldType              = "ar2"
SWEP.ViewModel             = "models/weapons/c_irifle.mdl" -- What the swep looks like to the user (Custom models can be used too)
SWEP.WorldModel            = "models/weapons/w_irifle.mdl" -- What the swep looks like to everyone else
SWEP.UseHands              = true -- Whether the swep will force the user to see the viewmodel's hands
SWEP.AutoSpawnable         = false -- Whether the swep will spawn upon map gen (override as false if EQUIP1/2)
SWEP.AmmoEnt               = "item_ammo_smg1_ttt" -- Which entity you pick up to fill your clips
SWEP.InLoadoutFor          = nil -- Which roles gain this weapon upon round start (table data structure)
SWEP.LimitedStock          = true -- If true only one can be bought per round
SWEP.AllowDrop             = true -- Is the player able to drop the swep
SWEP.IsSilent              = false -- If true, the killed player will not scream upon death
SWEP.NoSights              = false -- If true, the swep has no ironsights capability (no Secondary fire if ironsights?)
SWEP.HeadshotMultiplier    = 50 -- Multiply the headshot damage by this much
SWEP.DeploySpeed           = 0.2 -- Lower the slower
SWEP.IronSightsPos         = Vector(-2, -5, 0) -- Moves the Viewmodel by this vector when using ironsights
SWEP.IronSightsAng         = Vector(-2, 0, 0) -- Rotates the Viewmodel by this angle when using ironsights
```

These are most of the other miscellaneous values which can also be applied to the SWEP (That I have found, if any others are found to be applicable to TTT2 please notify us). Note that if any of these values are not explicitly stated in your lua file they will inherit the weapon_tttbase ones, or cause errors.

```lua
SWEP.Kind                 = WEAPON_EQUIP1 -- Kind specifies what weapon_ttt category it falls into
--[[
   (        0      1      2       3      4     5      6       7       8   ) SWEP.Slot
   (WEAPON_ MELEE, HEAVY, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2, ROLE) SWEP.Kind
--]]
```

+1 to the SWEP.Slot get the eqip slot key

```lua
SWEP.CanBuy                = {ROLE_TRAITOR} -- Which roles can purchase this swep (table)
```

This data is stored in a table, its the roles which can purchase it in the buy menu. Convention is that the keyword for each role is ROLE_\<ROLE NAME>.

## Template

Here is a [template weapon](https://github.com/cafelargo/TemplateSWEP) for reference to SWEP file structure.
If you want to do more than change default values to create different conventional SWEPs, view the [weapon_tttbase](https://github.com/TTT-2/TTT2/blob/master/gamemodes/terrortown/entities/weapons/weapon_tttbase.lua) file which ttt2 uses to base its SWEPs on.
