# Poupulate the Sidebar

While the sidebar is one HUD element, it is made from two ditinct parts: perks and status icons.

## Perks

Perks are the icons added after an equipment item is bought (A Second Chance, Disguiser, ...) and are a simple white icon on the HUD background. Adding perk symbols is really easy. An addon only needs one line added:

```lua
ITEM.hud = Material("vgui/ttt/perks/hud_nopropdmg.png")
```

Additionally a small indicator can be added where text can be rendered. It is advised however to keep the texts short (shorter than 3 characters):

```lua
function ITEM:DrawInfo()
    return math.random(0, 100)
end
```

[[See example here]](https://github.com/TTT-2/TTT2/blob/master/lua/terrortown/entities/items/item_ttt_nopropdmg.lua)

## Status

The status system builds on top of the perk system while also adding more features to it. To use the status system, a status has to registered first. This has to be done on the client.

```lua
hook.Add("Initialize", "my_addon_ininit", function()
    STATUS:RegisterStatus("unique_identifier", {
        -- sets the icon that will be rendered
        hud = Material("vgui/ttt/PATH.png"),
        -- the type that defines the color, it can be 'good', 'bad' or 'default'
        type = "bad",
        -- can be used to draw custom text on top of the status icon
        DrawInfo = function() return "Info" end,
        -- should not be used, is set automatically by type (intenal)
        hud_color = Color()
    })
end)
```

From now on the status can be added client and serverside with the same functions. The first argument has to be the player (or a table of multiple players) when called on a server. These functions are amongst others available:

```lua
STATUS:AddStatus([ply,] id)
STATUS:AddTimedStatus([ply,] identifier, duration, showDuration)
STATUS:RemoveStatus([ply,] id)
```

`AddTimedStatus` has the cool feature that the icon is removed automatically after a short time period. Additionally it starts to flash five seconds prior to its removal. If you want the left duration to be shown on the icon, you can pass `true` as `showDuration` parameter. This will automatically pass the left time to the DrawInfo callback. However this can't be used together with the previously shown `DrawInfo` function.

[[Check out this example]](https://github.com/TTT-2/ttt2-role_pri/blob/master/lua/terrortown/autorun/shared/sh_priest_sidebar.lua)

[[Full documentation in the code]](https://github.com/TTT-2/TTT2/blob/master/gamemodes/terrortown/gamemode/client/cl_status.lua)
