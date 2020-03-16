# Creating a HUD Theme

## Basics

A HUD theme is just a normal addon for TTT2 and therefore is in no way different than other addons. Check out the [getting started guide](/content-creation/creating-an-addon/) to learn more about creation of addons.

If you want to create a HUD element with the TTT2 system for one of your addons, check out [this article](/content-creation/creating-a-hudelement/).

## Basic Setup

In order to create a new HUD, you have to create a specific folder structure in your project.

```txt
<YOUR_ADDON>/
├── lua/
│   ├── autorun/
│   │   ├── your other lua files ...
│   │   └── ttt2_<YOUR_HUD_NAME>_force_download.lua
│   └── terrortown/
│       └── gamemode/
│           └── shared/
│               ├── hud_elements/
│               │   ├── base_elements/
│               │   │   └── <YOUR_HUD_NAME>_element.lua
│               │   ├── tttinfopanel/
│               │   │   └── <YOUR_HUD_NAME>_playerinfo.lua
│               │   └── bunch of others...
│               └── huds/
│                   └── <YOUR_HUD_NAME>/
│                       └── cl_init.lua
├── materials/
│   └── vgui/
│       └── ttt/
│           └── huds/
│               └── <YOUR_HUD_NAME>/
│                   └── preview.png
└── resource/
    └── fonts/
```

The `force_download` file in the `autorun` folder is not mendatory but recommended. You have to add the textures of your HUD, like the preview image found found in the `materials` folder, to a downloadlist at some place.

The file in `hud_elements/base_elements` is your base used by all of your following HUD elemenets. It is recommended to inherit from `dynamic_hud_element` to have all of the nice TTT2 features such as rescaling and repositioning. All your HUD elements will be placed in the same folder.

In order for your HUD to load at all, you have to create a `cl_init.lua` file in the right directory. It is the starting point of your custom HUD.

## Initialize your new HUD

To make a new HUD, you have to start with a initialization file. It is called `cl_init.lua` for our HUD system and it should be located in a folder with the name of your HUD inside the `hud` folder, shown in **`Basic Setup`**.

Besides defining the base class with

```lua
local base = "scalable_hud"
DEFINE_BASECLASS(base)
HUD.Base = base
```

a function for the initialization has to be defined in the next step. It loos like this:

```lua
function HUD:Initialize()
    -- something
end
```

Inside of this element all HUD elements belonging to you custom scheme have to be forced. Keep in mind that you are not forced to implement all HUD elements found in TTT2. You can implement whichever you want, even adding new ones. But it is recommended to implement and force at least the main elements such as `tttinfopanel` and `tttwswitch` since they are always displayed. Some elements needed in the game, such as `tttdrowning`, `tttmstack`, `tttsidebar` etc will use a fallback when not implemented by you.

Additionaly elements like `tttminiscoreboard` found in `pure_skin` will **not** use a fallback when not implemented by you. If you want to use this feature without adding you own style to it, force the `pure_skin` ones. An example would look like this:

```lua
function HUD:Initialize()
    self:ForceElement("octagonal_playerinfo")
    self:ForceElement("octagonal_wswitch")
    self:ForceElement("octagonal_drowning")
    self:ForceElement("octagonal_mstack")
    self:ForceElement("octagonal_sidebar")
    self:ForceElement("octagonal_punchometer")
    self:ForceElement("octagonal_target")

    -- use pure skin fallback for roundinfo elements
    self:ForceElement("pure_skin_roundinfo")
    self:ForceElement("pure_skin_teamindicator")
    self:ForceElement("pure_skin_miniscoreboard")

    BaseClass.Initialize(self)
end
```

Fonts, default color and the path of the preview image are defined in this file as well.

You can check out an example [here](https://github.com/TTT-2/ttt2-octagonal-hud/blob/master/lua/terrortown/gamemode/shared/huds/octagonal/cl_init.lua).

## Creating the Base Element

The base element of your hud should inherit from the TTT2 base hud element so you do not have to reimplement all the features such as rescaling, recoloring and repositioning. It is done like this:

```lua
local base = "dynamic_hud_element"
```

One important note is that the first part of this file name has to be the name of your hud!

Additionally this base class should be used for functions and variables that you use over and over again in your project. Since all following elements inherit from it, they are able to use this.

Check out the `octagonal_element.lua` from the octagonal HUD [here](https://github.com/TTT-2/ttt2-octagonal-hud/blob/master/lua/terrortown/gamemode/shared/hud_elements/base_elements/octagonal_element.lua). Feel free to copy the things needed for your HUD.

## Creating HUD Elements

All further elements should be based on your HUD element. //TODO

## Special Cases

//TODO about elements such as voice
