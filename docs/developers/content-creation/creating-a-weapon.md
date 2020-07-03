# Creating a Weapon

When starting content creation for gmod, creating a basic weapon using the SWEP structure is one of the easiest things you can do. For this guide I'll be using the Visual Studio Code with the glualint extension as referenced in the [Creating An Addon](/developers/basics/creating-an-addon.md) section of these documents. Using those instructions for setting up the editor and project structure/management will make it easier for us to support you with any problems while coding.

## File Format

The most important thing you must get right about weapons (or addons in general) is the folder structure. If your structure is all wrong, them gmod won't recognise the files and your addon will break.

### Weapon Lua Script

Your weapon's lua file must be in this format:

`<addon name>/gamemodes/terrortown/entities/weapons/weapon_ttt_/<weapon name>.lua`

### Icon Files

Your `*.vmt` and `*.vtf` icon files (what gets shown in the buy menu) will need to be stored in this format:

* `<addon name>/materials/vgui/ttt/<weapon name>_icon.vtf`
* `<addon name>/materials/vgui/ttt/<weapon name>_icon.vmt`

The basics about creating icons can be found [here](/developers/content-creation/icon-and-design-guideline/).

### Model Files

Model files for the SWEP will also need to be stored in the addon folder, unless you're using the default ones which come with source games. It's advised that even if you're using non-GMod models that you include them in the addon because not all users will own CS:S or Half life, etc.

* `<addon name>/materials/models/<model folder>/<model name>.vmt`
* `<addon name>/models/<model files>`

Documentation on how to create models will be uploaded soon.

GMod default weapon model paths are found [here](https://wiki.facepunch.com/gmod/Common_Weapon_Models).

### Sound Files

Custom sounds for your SWEP will need to be stored in this folder if you're not going to use the default sounds from GMod. This has the benefit that they're only loaded when you're using the ttt/2 gamemode.

`<addon name>/gamemodes/terrortown/content/sound/`

???+ note
    Sounds types accepted are: `*.wav`, `*.mp3` and `*.ogg`.

GMod default sound paths are found [here](https://wiki.facepunch.com/gmod/Common_Sounds).

### Language files

It would be greatly appreciated if you included support for multiple languages into your addon so that it becomes more accessible for users. Extra accessiblilty will also help with getting your addon noticed and downloaded if you're planning on uploading it to the Workshop. When you want a string (e.g. the description in the buy menu) to be translated, you place in a language identifier instead. A language identifier is placed in each file as a variable name and the value of which is the translation.

Each language file will need to be stored in this format:

`<addon name>/lua/lang/<language folder>/<lang file name>.lua`

???+ note
    The language identifier should be unique to prevent clashes with other addons' translations.

See the [Language Support](/developers/content-creation/language-support/) page for more information on this topic.

See the [Creating An Addon](/developers/basics/creating-an-addon.md/#project-structure) page for more info on folder structure.

## A Basic Template

### Serverside Initialization

```lua
if SERVER then
    -- Shares the specified file with the client (if blank shares current file)
    AddCSLuaFile()

    -- Shares the buy menu icon with the client
    resource.AddFile("materials/vgui/ttt/blue_template_icon.vmt")
end
```

It's very important to create a globally unique name for this because the Gmod client will look for the given path locally to display it. So if there are two identical icon names the client may display the incorrect one.

### Clientside Initialization

```lua
if CLIENT then
    -- How much of the first person viewmodel is seen
    SWEP.ViewModelFOV       = 70
    -- If true, the viewmodel is on the left
    SWEP.ViewModelFlip      = true
    -- Does the client draw its own crosshair over the default ones
    SWEP.DrawCrossHair      = false

    -- The filename of the icon shown in the buymenu
    SWEP.Icon = "vgui/ttt/blue_template_icon.vtf"

   -- The information shown in the buy menu
    SWEP.EquipMenuData = {
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
-- Higher is slower
SWEP.Primary.Delay         = 0.001
-- Is it automatic
SWEP.Primary.Automatic     = true
-- How much damage per shot
SWEP.Primary.Damage        = 1
-- Cone of accuracy
SWEP.Primary.Cone          = 0.5
-- Which ttt ammo entity is picked up by this swep, 'none' for no ammo type
SWEP.Primary.Ammo          = "smg1"
-- Maximum clip size
SWEP.Primary.ClipSize      = 100
-- Starting clip size
SWEP.Primary.DefaultClip   = 100
-- Either a sound file from the default list or a custom one
SWEP.Primary.Sound         = Sound("Weapon_AK47.Single")
-- Number of shots fired at one time (make into shotgun if increase conde val)
SWEP.Primary.NumShots      = 1
-- Recoil value (bigger = bigger)
SWEP.Primary.Recoil        = 1.5
```

???+ note
    All of these attributes can also be applied to SWEP.Secondary which is right click by default.

```lua
SWEP.HoldType              = "ar2"
-- What the swep looks like to the user (Custom models can be used too)
SWEP.ViewModel             = "models/weapons/c_irifle.mdl"
-- What the swep looks like to everyone else
SWEP.WorldModel            = "models/weapons/w_irifle.mdl"
-- Whether the swep will force the user to see the viewmodel's hands
SWEP.UseHands              = true
-- Whether the swep will spawn upon map gen (override as false if EQUIP1/2)
SWEP.AutoSpawnable         = false
-- Which entity you pick up to fill your clips
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"
-- Which roles gain this weapon upon round start (table data structure)
SWEP.InLoadoutFor          = nil
-- If true only one can be bought per round
SWEP.LimitedStock          = true
-- Is the player able to drop the swep
SWEP.AllowDrop             = true
-- If true, the killed player will not scream upon death
SWEP.IsSilent              = false
-- If true, the swep has no ironsights capability (no Secondary fire if ironsights?)
SWEP.NoSights              = false
-- Multiply the headshot damage by this much
SWEP.HeadshotMultiplier    = 50
-- The lower the slower
SWEP.DeploySpeed           = 0.2
-- Moves the Viewmodel by this vector when using ironsights
SWEP.IronSightsPos         = Vector(-2, -5, 0)
-- Rotates the Viewmodel by this angle when using ironsights
SWEP.IronSightsAng         = Vector(-2, 0, 0)
```

These are most of the other miscellaneous values which can also be applied to the SWEP. Note that if any of these values are not explicitly stated in your lua file they will inherit the `weapon_tttbase ones`.

In TTT2 the `SWEP.Slot` is automatically calculated from the `SWEP.Kind`. Therefore only the latter has to be set.

```lua
-- Kind specifies what weapon_ttt category it falls into
SWEP.Kind                 = WEAPON_EQUIP1
```

| `SWEP.Kind` | `WEAPON_MELEE` | `WEAPON_PISTOL` | `WEAPON_HEAVY` | `WEAPON_NADE` | `WEAPON_CARRY` |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `SWEP.Slot` | 1 | 2 | 3 | 4 | 5 |

| `SWEP.Kind` | `WEAPON_UNARMED` | `WEAPON_SPECIAL` | `WEAPON_EXTRA` | `WEAPON_CLASS` |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `SWEP.Slot` | 6 | 7 | 8 | 9 |

```lua
-- Which roles can purchase this swep (table)
SWEP.CanBuy                = {ROLE_TRAITOR}
```

This data is stored in a table, its the roles which can purchase it in the buy menu. Convention is that the keyword for each role is ROLE_<ROLE NAME\>. However the serveradmin can change those values at a later point in the shopeditor found ingame.

## Template

Here is a [template weapon](https://github.com/cafelargo/TemplateSWEP) for reference to SWEP file structure.
If you want to do more than change default values to create different conventional SWEPs, view the [weapon_tttbase](https://github.com/TTT-2/TTT2/blob/master/gamemodes/terrortown/entities/weapons/weapon_tttbase.lua) file which ttt2 uses to base its SWEPs on.
