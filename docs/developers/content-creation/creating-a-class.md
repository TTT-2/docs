# Creating a Class

To create a class, the function `CLASS.AddClass(name, classData, conVarData)` has to be called on both client and server.

```lua
-- Example 1 - A basic class

CLASS.AddClass("YOURCLASS", {
    color = Color(149, 188, 195, 255),
    lang = {
        name = {
            English = "Your Class",
            Deutsch = "Deine Klasse"
        },
        desc = {
            English = "A class description",
            Deutsch = "Eine Klassenbeschreibung"
        }
    }
})
```

Shown in **`example 1`** is a basic class with only a name and a color and no active features. This file has to be stored in `<your_addon>/lua/classes/classes/<this_file>.lua` to be registered automatically on both client and server.

## Name

The `name` parameter of the class is a unique identifier for your new class that can be used for example in hooks to make sure they only are active for players of this specific class.

## ClassData

The `classData` argument is a table that contains all the important class settings.

### General Class Settings

???+ example "Setting the Class Color"
    The class color is stored in the color variable. This color value is used to display the class in the HUD and in other places like targetID.

    ```lua
    classData.color = <Color> -- [default: Color(255, 155, 0, 255)]
    ```

???+ example "Setting the Language"
    The language for the class consists of two parts: The name and the description. At least the name should be set, but it is good practise to set the description as well.

    The existing language identifiers can be found [inside these files](https://github.com/TTT-2/TTT2/tree/master/gamemodes/terrortown/gamemode/shared/lang). Currently these identifiers exist: `English`, `Deutsch`, `Русский`, `Polski`, `Italiano`

    ```lua
    classData.lang = {}
    ```

???+ example "Setting a Class to Be Passive"
    By default, classes are active. This means that they have an ability that is enabled on keypress and can only be used once activated. Besides these active feature, classes can have passive features as well (like armor for a class). However, if your class should only have passive features, set this variable to `true`.

    ```lua
    classData.passive = <boolean> -- [default: false]
    ```

???+ example "Surpress Keep on Respawn"
    If `true`, the player won't get the class back on respawn, no matter how the ConVar `ttt_classes_keep_on_respawn` is set.

    ```lua
    classData.surpressKeepOnRespawn = <boolean> -- [default: false]
    ```

    See [the Vendetta](https://github.com/TTT-2/ttt2h-pack-default/blob/master/lua/classes/classes/class_vendetta.lua) for an example.

???+ example "Class is Active During Death"
    Should be set to `true`, if the class is getting active after the players death and should not get removed after death. This information is important for other addons like "TTTC Class Dropper".

    ```lua
    classData.activeDuringDeath = <boolean> -- [default: false]
    ```

    See [the Vendetta](https://github.com/TTT-2/ttt2h-pack-default/blob/master/lua/classes/classes/class_vendetta.lua) for an example.

???+ example "Deactivate Automatic Class Handling"
    The class system handles each feature in predefined functions. However you might want to create a really custom class that does not rely on any standard implementations. By setting this variable to `true`, none of the following functions and tables will be used.

    ```lua
    classData.deactivated = <boolean> -- [default: false]
    ```

    See [the Vendetta](https://github.com/TTT-2/ttt2h-pack-default/blob/master/lua/classes/classes/class_vendetta.lua) for an example.

### PASSIVE ABILITY

???+ example "Passive Weapons"
    A table of weapons given to the player once the class is set, they are automatically removed when the class is removed from the player. You can use the hook `TTTCPreventClassEquipment` to prevent the weapon hand-out and `TTTCPreventClassRemovement` to prevent the weapon removal to happen.

    ```lua
    classData.passiveWeapons = {}
    ```

???+ example "Passive Items"
    A table of items given to the player once the class is set, they are automatically removed when the class is removed from the player. You can use the hook `TTTCPreventClassEquipment` to prevent the item hand-out and `TTTCPreventClassRemovement` to prevent the item removal to happen.

    ```lua
    classData.passiveItems = {}
    ```

???+ example "On Class Set Callback"
    A function that is called when this class is given to a player after class change or on respawn. You can use the hook `TTTCPreventClassEquipment` to prevent this function to happen.

    ```lua
    classData.onClassSet = function(ply) -- [default: nil]
    ```

???+ example "On Class Unset Callback"
    A function that is called when this class is removed from a player. You can use the hook `TTTCPreventClassRemovement` to prevent this function to happen.

    ```lua
    classData.onClassUnset = function(ply) -- [default: nil]
    ```

### Active Ability

???+ example "Active Weapons"
    A table of weapons given to the player once the class is activated, they are automatically removed when the class is deactivated or removed from the player.

    ```lua
    classData.weapons = {}
    ```

???+ example "Passive Items"
    A table of items given to the player once the class is activated, they are automatically removed when the class is deactivated or removed from the player.

    ```lua
    classData.items = {}
    ```

???+ example "Active Time"
    The time how long the ability is enabled after the player activated it. If set to `0`, `onActivate` isn't called. You have to use `onDeactivated` in this case. This can be used for classes that have no active ability, but an ability that triggers an event.

    ```lua
    classData.time = <number> -- [default: 60]
    ```

    See [the Nebula](https://github.com/TTT-2/ttt2h-pack-default/blob/master/lua/classes/classes/class_nebula.lua) for an example of an event ability with a time of `0`.

???+ example "Cooldown Time"
    The cooldown time after the usage of the active ability.

    ```lua
    classData.cooldown = <number> -- [default: 60]
    ```

???+ example "Charging Time"
    Defines how long the activation key must be pressed to activate the ability, `nil` for instant activation.

    ```lua
    classData.charging = <number> -- [default: nil]
    ```

???+ example "Max Activation Amount Per Round"
    Defines how many times an ability can be activated per round, `nil` for infinite times.

    ```lua
    classData.amount = <number> -- [default: nil]
    ```

???+ example "Endless Class Ability"
    If `true`, the time of an ability is infinite and `time` is ignored.

    ```lua
    classData.endless = <boolean> -- [default: false]
    ```

???+ example "Unstoppable Class Ability"
    If `true`, the player can not disable the ability once they pressed the ability key.

    ```lua
    classData.unstoppable = <boolean> -- [default: false]
    ```

???+ example "Avoid Weapon Reset"
    By default, all weapons from the player inventory get removed once they activate their class ability. These weapons are given back after the ability is deactivated. If set to `true`, the player keeps his weapons while the class ability is active.

    ```lua
    classData.avoidWeaponReset = <boolean> -- [default: false]
    ```

???+ example "On Class Activate Callback"
    A function that is called on activation of an ability. If `avoidWeaponReset` is set to `false` weapons will be removed prior to this function call.

    ```lua
    classData.onActivate = function(ply) -- [default: nil]
    ```

???+ example "On Class Deactivate Callback"
    A function that is called on deactivation of an ability. If `avoidWeaponReset` is set to `false` weapons will be given back prior to this function call.

    ```lua
    classData.onDeactivate = function(ply) -- [default: nil]
    ```

???+ example "On Class Prepare Callback"
    A function that is called prior to `onActivate`. If this function is set, the ability will be activated on the next ability-key press. This can be used to have a two step activation procedure

    ```lua
    classData.onPrepareActivation = function(ply) -- [default: nil]
    ```

    See [the Frost](https://github.com/TTT-2/ttt2h-pack-default/blob/master/lua/classes/classes/class_frost.lua) for an example.

???+ example "On Class Finish Prepare Callback"
    This function will only be called if `onPrepareActivation` was set. It is called on the second press of the ability key and is done directly before `onActivate`. If the ability was canceled in this process, this function is called prior to `onDeactivate`.

    ```lua
    classData.onFinishPreparingActivation = function(ply) -- [default: nil]
    ```

    See [the Frost](https://github.com/TTT-2/ttt2h-pack-default/blob/master/lua/classes/classes/class_frost.lua) for an example.


???+ example "On Class Charge Callback"
    This function is called once every frame after while a player is in the charging process, if the function is set and returns `nil` or `false`, the charging process is stopped.

    ```lua
    classData.onCharge = function(ply) -- [default: nil]
    ```

???+ example "Check Class Activation Callback"
    This function is called when the ability should be activated. Activation fails if the function is set and returns `nil` or `false`.

    ```lua
    classData.checkActivation = function(ply) -- [default: nil]
    ```

## ConVarData

The `conVarData` table holds all default values for the convars to modify the class.

???+ example "Class Random"
    This defines the spawn chance of a class.

    ```lua
    conVarData.random = <number> -- [default: 100]
    ```

# Other Resources

- See the TTT2 docs for more infotamtion about TTT2 and TTTC hooks [coming soon!]
- See [this class](https://github.com/TTT-2/tttc-class_shooter/blob/master/lua/classes/classes/class_shooter.lua) for a really simple example
- Check out [this folder](https://github.com/TTT-2/ttt2h-pack-default/tree/master/lua/classes/classes) and [that folder](https://github.com/TTT-2/tttc-class_pack/tree/master/lua/classes/classes) for a bunch of examples
