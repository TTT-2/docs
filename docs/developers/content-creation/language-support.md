# Language Support

While the language registration from the original TTT still works as intended, TTT2 features its own way more conventient language registration system. By keeping all language strings in a seperate file, it is cleaner looking and easier for people who want to translate certain strings into other languages.

## Adding a Language File

To add a language file, a file with a unique name has to be created in `<addon_name>/lua/lang/<some_folder>/<your_file>.lua`. In general the `some_folder` is the language identifier and `your_file` is based on your addon name.

A finished translation structure should look like this with at least english being provied:
```txt
<YOUR_ADDON>/
└── lua/
    └── lang/
        ├── deutsch/
        |   └── pharoah.lua
        ├── english/
        |   └── pharoah.lua
        └── italiano/
            └── pharoah.lua
```

## Filling the Language Files

Filling the language file with content is pretty straight forward. In the first line, the language table reference has to be retreived. Following this, the returned table can be filled with contents

```lua
L = LANG.GetLanguageTableReference("english")

-- GENERAL ROLE LANGUAGE STRINGS
L[PHARAOH.name] = "Pharaoh"
L["info_popup_" .. PHARAOH.name] = [[You are the Pharaoh!
Use your Ankh to your benefit. Place it in a strategic position and make sure it is protected!]]
-- ...

```
???+ note "A Note on Language Identifiers"
    Language identifers have to be unique. If they are used multiple times in different addons, they will overwrite each other and only one of them will be used. The same holds true for the language file names. Make sure that the filename is descriptive and not used by any other addon.

To allow param translation, a keyword has to be placed inside curly brackets.

```lua
L["ankh_health_points"] = "Health: {health} / {maxhealth}"
```

You can check out an example [here](https://github.com/TTT-2/ttt2-role_pha/tree/master/lua/lang).

## Using the Language Strings

### Direct Translation

The most direct way to use the now defined language strings is by using one of the three translation functions provided in TTT2. The identifier is the unique string that wa assigned to the translation in the translation file.

`LANG.GetTranslation(identifier)`: This is the most basic way to translate a string. If no string with the identifier exists, an error string is returned.

`LANG.TryTranslation(identifier)`: A more robust version of the first function. It does the same but returns the identifier if no language string was found. This is especially useful in situations where you can't be sure if a translation exists.

`LANG.GetParamTranslation(identifier, params)`: A more advanced version that supports translations with placeholders. This can be used to insert a nick name into a translated string where these placeholders are surrounded by curly brackets.

### Serverside Translation

Since translations are done client side, custom networking has to be added if a message should be issued from the server. However there is a workaround suitable for most cases: `LANG.Msg()`. This function automatically networks the message to the client and translates it there to the correct language. This system is based on param translations.

`LANG.Msg(receipient, identifier, params, type)`:
- `receipient`: Either a player or a table of players that should receive this message
- `identifier`: The string language identifier
- `params`: A table of parameters that are used in the param translation
- `type`: The type of the message

The type of the message can have different types depending on where and in which color the message should be shown. The following types are available:
- `MSG_MSTACK_ROLE`: MStack message with the role color as background color
- `MSG_MSTACK_WARN`: MStack message with a red background color
- `MSG_MSTACK_PLAIN`: MStack message with the HUD color as background color
- `MSG_CHAT_ROLE`: Chat message with the role color as color
- `MSG_CHAT_WARN`: Chat message with a red color
- `MSG_CHAT_PLAIN`: Chat message with the default chat color
- `MSG_CONSOLE`: Message that is printed to the console

### Translation Supported Functions

Besides manual translation as shown above, many functions provided by TTT2 already support language identifiers. Check the documentation of said functions to see if you have to translate it by yourself or if it automatically translated. In general the latter is the case.
