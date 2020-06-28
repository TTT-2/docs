# Creating a Weapon
When starting content creation for gmod, creating a basic weapon using the SWEP structure is one of the easiest things you can do.
For this guide I'll be using the Visual Studio Code with the glualint extension as referenced in the "Creating an addon" section of these documents.

## File Format

Firstly you need to make sure that you're using the correct folder structure.
Your addon folder must be in this format:
* weapon_ttt_<weapon name>\gamemodes\terrortown\entities\weapons\weapon_ttt_<weapon name>.lua
 
If you want it to be compatible with sandbox, put a copy of your lua file in:
* weapon_ttt_<weapon name>\lua\weapons\weapon_ttt_<weapon name>.lua
 
See the [Creating An Addon](https://docs.ttt2.neoxult.de/developers/basics/creating-an-addon/) page for more info on folder structure
 
## Template
Here is a [template weapon](../../assets/luafiles/weapon_ttt_template.lua) for reference.
If you want to do more than change default values to create different conventional firearms, view the [weapon_tttbase](https://github.com/TTT-2/TTT2/blob/master/gamemodes/terrortown/entities/weapons/weapon_tttbase.lua) file which ttt2 uses to base its SWEPs on.
