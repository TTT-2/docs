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
???+ note "ON Language Identifiers"
    Language identifers have to be unique. If they are used multiple times in different addons, they will overwrite each other and only one of them will be used. The same holds true for the language file names. Make sure that the filename is descriptive and not used by any other addon.

You can check out an example [here](https://github.com/TTT-2/ttt2-role_pha/tree/master/lua/lang).
