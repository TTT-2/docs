# Creating a Weapon
When starting content creation for gmod, creating a basic weapon using the SWEP structure is one of the easiest things you can do.
For this guide I'll be using the Visual Studio Code with the glualint extension as referenced in the "Creating an addon" section of these documents.

Firstly you need to make sure that you're using the correct folder structure.
Your addon folder must be in this format.
  weapon_ttt_<weapon name>\gamemodes\terrortown\entities\weapons\weapon_ttt_<weapon name>.lua
  weapon_ttt_<weapon name>\materials\vgui\ttt\<weapon name>_icon.vmt
  weapon_ttt_<weapon name>\materials\vgui\ttt\<weapon name>_icon.vtf
  weapon_ttt_<weapon name>\materials\models\<model name>.dx80
  weapon_ttt_<weapon name>\materials\models\<model name>.dx80
  weapon_ttt_<weapon name>\materials\models\<model name>.dx80
  weapon_ttt_<weapon name>\materials\models\<model name>.dx80
  weapon_ttt_<weapon name>\materials\models\<model name>.dx80
  weapon_ttt_<weapon name>\materials\models\<model name>.dx80
  weapon_ttt_<weapon name>\materials\models\<model name>.dx80
If you want it to be compatible with sandbox, put a copy of your lua file in:
  weapon_ttt_<weapon name>\lua\weapons\weapon_ttt_<weapon name>.lua
