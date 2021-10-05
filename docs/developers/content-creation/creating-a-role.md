# Creating a Role

## Foreword

This article assumes basics, such as that a development environment has already been set up. If this prior knowledge is not yet available, the [corresponding article](https://docs.ttt2.neoxult.de/developers/basics/creating-an-addon/) should be read first. It should also be said that this tutorial is intended to convey basic knowledge. It is intended to convey a feeling for being able to develop one's own roles for TTT2. Special topics are therefore not covered. At the very bottom, I also provide all the code.

## Role Variables

### Scoring

There are a few variables that influence the scoring of the role. They are all in the `score` table of the role. Here are the existing variables from the role base with their default values.

```lua
-- The multiplier that is used to calculate the score penalty
-- that is added if this role kills a team member.
teamKillsMultiplier = 0,

-- The multiplier that is used to calculate the gained score
-- by killing someone from a different team.
killsMultiplier = 0,

-- The amount of score points gained by confirming a body.
bodyFoundMuliplier = 1,

-- The amount of score points gained by surviving a round,
-- based on the amount of dead enemy players.
surviveBonusMultiplier = 0,

-- The amount of score points granted due to a survival of the
-- round for every teammate alive.
aliveTeammatesBonusMultiplier = 1,

-- Multiplier for a score for every player alive at the end of
-- the round. Can be negative for roles that should kill everyone.
allSurviveBonusMultiplier = 0,

-- The amount of score points gained by being alive if the
-- round ended with nobody winning, usually a negative number.
timelimitMultiplier = 0,

-- the amount of points gained by killing yourself. Should be a
-- negative number for most roles.
suicideMultiplier = -1
```

[[Find them in the role base]](https://github.com/TTT-2/TTT2/blob/master/lua/terrortown/entities/roles/ttt_role_base/shared.lua)

## Setting up the files 

Before we can dive into the lua programming, we must set up the role’s file structure, so that the role is detected by TTT2 as such. But this is not only depending on the file structure. Another important aspect is the initial code, which is the same for every role.

### Folder structure

Every role has the same folder structure. As a little side note: You can name the role’s folder like you want, but if you want to fit the most other roles, you should name the folder  `ttt2-role_[abbreviation of the role]”`.

Inside this folder you will need another folder that must be called “lua” and then “terrortown”. In the terrortown-folder the structure is split into 3 parts:
1. the files for the translation
2. the main code
3. the convar files 

#### Translation files

I will explain only the basics here. For further information, go [this way](https://docs.ttt2.neoxult.de/developers/content-creation/language-support/#adding-a-language-file).

For the translation files, you must fit the the following structure: `tt2-role_test/lua/terrortown/lang/en/tester.lua”`. 

Let me explain this structure, before we’re getting to the next one. As I explained above `ttt2-role_test` is the parent folder. After that we’ve got the lua and terrortown folders. These are needed to tell TTT2 that there are files, that it shall load. The “lang”-folder contains all languages that this role is translated to. Since the global language is English and there is no getting around this language in programming, you should definitely offer your role in English. If you want to add other translations you just can add here other language folders, due to the TTT2 [language support system](https://docs.ttt2.neoxult.de/developers/content-creation/language-support/). For example:

`ttt2-role_test/lua/terrortown/lang/de/tester.lua`

This would also add a german translation. Or:

`ttt2-role_test/lua/terrortown/lang/it/tester.lua`

For an italian translation. 

A `[your role name here].lua` is then added to each language folder. There is no need to name the folder between "lang" and the `tester.lua` like that, but for better readability it is recommended to do so. We will discuss what this file does and what is written in it in a moment.

#### The main files

Now we come to the most important files of the role. Basically, only the following paragraph would be relevant to develop the a functional role. But under it the clarity would suffer because of missing structure then too. These files contain the function code that gives the role the functionality it is supposed to fulfil. 
That directory must look like this:

`ttt2-role_test/lua/terrortown/entities/roles/tester/shared.lua`

The interesting part here is the “tester”-folder and the `shared.lua`. This folder always bears the name of the role. The shared.lua is then the source file of the role. 

You might ask, why this file is named `shared` and not `tester` like all the other files. 
In Garry’s Mod we can code on 2 levels: The server and the client. The server handles the data that is transferred between the clients. Programming on server level means that we can change data that is affecting all clients or a certain group of clients etc. To be specific: Everything that has to do with the game mode or must be handled globally, and this includes the function of a role, is developed server-side. On the client’s side we can change things that is only by the client themselves, e.g. HUD elements. This also means that you cannot change anything related to TTT2 client-side. 

In Garry’s Mod there are 2 ways to access either the client or the server:
You can name a folder `server` or `client`. Every file in that folder then can be handled server-side or client-side. The problem: This is static. You cannot switch this while running the code. So these files will then always be handled only on the client or on the server.

The second way now also explains, why the main code file is named `shared.lua`. If a file or folder is declared as shared, both client-side code and server-side code can be executed within it. And because we want to run both server and client code in the role code, the main file is called `shared.lua`.

#### The ConVar files

ConVars `(abbr. for “console variable”)` are used to store information on the server and the client by using the console. In TTT2 role coding we use them to give players the posibility change the options of the roles to their liking and thus customise each role to their playing style.

It is recommended to place the ConVar file here:

`ttt2-role_test/lua/terrortown/autorun/shared/sh_tester_convars.lua`

The autorun folder contains files that are loaded automatically when the server is (re-)starting. The name of the actual lua file consists of 3 different parts:
“sh”: This is the abbreviation of shared.
“tester”: the role’s name.
And “convars”.

This naming may look mandatory, but it is not. You can name the file whatever you want. However, if you want to follow the regular naming conventions in TTT2 development, you should name the files as described here.

What’s to be written in there, will be explained in the “Optionals” chapter.  

#### Icon files

Last, but not least, we must deal with the icon files. They won’t be placed in the lua-folder. They must be placed here:

`ttt2-role_test/materials/vgui/ttt/dynamic/roles`

In Order to get the icon working, you must place the icon files (a vmt- & a vtf-file) in the “roles”-folder. 
I will not go into more detail here, as this is already explained in more detail in [another article](https://docs.ttt2.neoxult.de/developers/content-creation/icon-and-design-guideline/).

#### An overview to the file structure

To avoid possible misunderstandings, you can see here how the file structure should look like.

```text
<YOUR_ROLE>/
├── lua/
│   └── terrortown/
│       ├── autorun/
│       │   └── shared/
│       │   	└── sh_<YOUR_ROLE_NAME>_convars.lua
│       ├── entities/
│       │   └── roles/
│       │       └── <YOUR_ROLE_NAME>/
│ 	│	    └── shared.lua
│	└── lang/
|	    ├── en/
|	    |   └── <YOUR_ROLE_NAME>.lua
|	    ├── de/
|	    |   └── <YOUR_ROLE_NAME>.lua
|	    └── ../	
|	        └── <YOUR_ROLE_NAME>.lua
└── materials/
    └── vgui/
        └── ttt/
            └── dynamic/
                └── roles/
                    ├── icon_<YOUR_ROLE_ABBREVIATION>.vmt
                    └── icon_<YOUR_ROLE_ABBREVIATION>.vtf

```

Keep in mind that some namings are recommended and not mandatory. You can change them to whatever you want.

## Start Coding

### Preparations

To show you the creation of TTT2 roles we will create a traitor role together. This traitor is going to have access to the detective shop and his HP will set to a specific amount, if one of his colleagues dies. If the maximum is reached, it increases by another corresponding amount instead.

Now that we have an idea, we can get down to the implementation.
Every role has a similar structure. There are aspects that are the same for all roles. Because of this, we take care of them first. There are even aspects that are the same for all Garry’s Mod addons. 
Start your lua file by adding this:

```lua
if SERVER then
    AddCSLuaFile()
end
```

This [command](https://wiki.facepunch.com/gmod/Global.AddCSLuaFile) does not seem to be important, but it is elementary to make the addon workable. `AddCSLuaFile()` tells the server to send this file to client when they join the server. 

The block around it `if SERVER then...end` was mentioned before when describing what “shared” means. If you want to execute a command block server-side, you write just that around the block. If you want to execute the commands client-side, write `if CLIENT then...end` instead.

For now, we leave this block alone, but we will come back to it later. 
The next two functions initialize the role. This process happens in the loading screen and makes the role ready for the first round. The data required for the basic operation of the role is stored in the functions. Also in this structure the roles hardly differ, because this still has nothing to do with the individual ability of it. For this reason, you can easily copy the following section:

```lua
function ROLE:PreInitialize()
  	self.color                      = Color(209, 98, 90, 255)

	self.abbr                       = "test"
	self.surviveBonus               = 0
	self.score.killsMultiplier      = 2
	self.score.teamKillsMultiplier  = -8
	self.preventFindCredits         = false
	self.preventKillCredits         = false
	self.preventTraitorAloneCredits = false
	self.preventWin                 = false
	self.unknownTeam                = false

	self.defaultTeam                = TEAM_TRAITOR

	self.conVarData = {
		pct          = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum      = 1, -- maximum amount of roles in a round
		minPlayers   = 7, -- minimum amount of players until this role is able to get selected
		credits      = 2, -- the starting credits of a specific role
		shopFallback = SHOP_FALLBACK_DETECTIVE, -- granting the role access to the shop
		togglable    = true, -- option to toggle a role for a client if possible (F1 menu)
		random       = 33
	}
end

function ROLE:Initialize()
    roles.SetBaseRole(self, ROLE_TRAITOR)
end
```

I will not explain every line in detail, but I will explain the aspects that are important for our role now. Keep also in mind that you must edit this block for every role because it contains data that differs from role to role. 
The first line defines the role’s [color](https://wiki.facepunch.com/gmod/Global.Color). It uses RGBA. Should you only be familiar with RGB: The "A" stands for alpha and defines the opacity. For role development, you should simply leave the fourth value for the color at 255. For us, only the first three values are of interest. These follow the RGB spectrum. In principle, you can give your role any color you want, but it is recommended to give Detective roles blue tones, Innocent roles green tones and Traitor roles red tones. For this role I’ve chosen a light red tone. 
`self.abbr` defines the abbreviation of the role. We used it a few times already. The perfect length for the abbreviation is 3-5 characters. 

`self.score.killsMultiplier` & `self.score.teamKillsMultiplier` is the multiplier that definies the player’s score when performing (team) kills. You can find more information to the scoring parameters [here](https://docs.ttt2.neoxult.de/developers/content-creation/creating-a-role/#scoring).

`self.preventFindCredits`, `self.preventKillCredits` & `self.preventTraitorAloneCredits` should be true when the player shall not get credits throughout the round, else it should be false. For example, if you program an Innocent role, these values should be set to true.

`self.defaultTeam` sets the role’s team. Because we are coding a traitor, it is set to `TEAM_TRAITOR`.

The next one `self.conVarData` is not just a simple value, but a structure that you will see again and again on your way as a programmer and also use yourself. This structure is called table, recognizable by the curly brackets. Such tables can contain different contents. In this case here several ConVars. 
The ConVar values are explained through comments besides them. 
In the function `ROLE:Initialize` we set the base role to traitor. This makes the Tester role a sub role whose parent is the Traitor role. Note: Setting a base role isn’t always necessary. For example, if you want to develop a role that has its own team, the declaration of a Base Role can be omitted. But this is not always the case.

By now the role can almost be put on the server and get launched. Only the translation files are missing. 

### Translating the role

To do that, we must change the file, we are editing. Save, the shared.lua and switch to the tester.lua in 

`ttt2-role_test/lua/terrortown/lang/en`

Once again, you can copy the following and I will explain it to you, step by step:

```lua
L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[TESTER.name] = "Tester"
L["info_popup_" .. TESTER.name] = [[You are the Tester!
If If one of your Traitor colleagues dies, your HP increases by a certain value.]]
L["body_found_" .. TESTER.abbr] = "They were a Tester."
L["search_role_" .. TESTER.abbr] = "This person was a Tester!"
L["target_" .. TESTER.name] = "Tester"
L["ttt2_desc_" .. TESTER.name] = [[The Tester needs to win with the traitors!]]
```

The first line couples the translation with the respective language. Because this here is the english translation, we put in there “en”. The following block then is used for the in-game texts. 
The first one is the role’s name.

“info_popup” is used is used for the pop up that appears at the bottom of the screen when the round starts and explains the player's role.

“body_found” declares the text that is shown in the upper right corner when the tester’s corpse was found. 

“search_role”  is the text that the player sees when searching the tester's body.

“ttt2_desc_” is the description wit whom the tester wins. Since the tester is a traitor, it says that he wins with just them.  If you were developing a role with its own team, you could write here that role XY wins alone.

You might noticed the “TESTER” inside the square brackets. If you were to develop another role, you would have to change this "TESTER" to the name of your role. For example, if you were developing the Arsonist, it would say "ARSONIST" instead of "TESTER".

### Test the role

Now we can load our role for the first time. Save the translation file, copy the whole role folder and paste it inside the GMod addons directory. To find that you want to go into the local files of Garry’s Mod. Once you’re there, just open `garrysmod/addons`. 

If you haven’t done it already, go into the Garry’s Mod control options and bind a key to open the developer console. 
 
To make things easier, I am using ULX for TTT2. I recommend to use it as well. You can find it [here](https://steamcommunity.com/sharedfiles/filedetails/?id=1362430347&searchtext=ttt2+ulx)

Now we can open up a lobby and play the role for the first time.

If the role selection does not give you the role, you can give it to you with using the "force" command. With the Shop key (key “C” by default), you should be able to open up the detective shop. And you should also see in the HUD on the screen’s top, you are a member of the traitor team.

If you can see all this, the role is working by now, as intended. Don’t worry about the black-pink squares in the icon area. Since we have not inserted an icon up to this point, this is completely normal and need not concern us further.

### Giving the role its functionality

Now we will give the role its function. As mentioned before, the function of the role will be calculated later by the server. For this reason, the function block must be programmed server-side. 

Next, you'll get to know a construct that you'll come across again and again, and will also use it yourself, since its importance in Garrys Mod development is very high: Hooks. 
Hooks are not only used in TTT, but can also be found in Garry's mod in general. However, in the explanation and functionality of hooks I will explicitly deal with TTT. 

[Hooks](https://wiki.facepunch.com/gmod/Hook_Library_Usage) are basically events that are called when their condition is met. A round of TTT is basically a series of hook calls. Whenever the circumstances in a round change, hooks come into play. Using hooks, we define how the role should react when something specific happens. If the explanation still leaves you a little confused, don't worry. Hooks are often self-explanatory when you apply them.
Since we want to adjust the HP of our role when one of the Traitor colleagues dies, we need a hook that is called when a player dies. For this, Garry's mod provides us with the ["PlayerDeath" hook](https://wiki.facepunch.com/gmod/GM:PlayerDeath). 
Open the linked GMOD Wiki page to understand the hook better. To be able to use a hook, we need to add it to our code. We can do this with the `hook.Add()` command. Garry's Mod expects us to supply 3 parameters with this command. The first place is for the name of the hook we want to call. In our case "PlayerDeath" . The second one is for the identifier. This is used to give the hook a name that can be used to recognize it. To prevent overwriting, this identifier should be a bit more extensive. It is probably best to name the hook `ttt2_heal_up_tester`. The third and last place is reserved for the function to be executed when the hook is called. This function in turn also has 3 parameters that we can use: `victim, inflictor, attacker`. As described in the GMOD Wiki article, "victim" is the player who died, "inflictor" is the item used for this and "attacker" is the player or entity that killed the "victim".

```lua
hook.Add("PlayerDeath", "ttt2_heal_up_tester", function(victim, inflictor, attacker)
    -- Code to be processed must be filled in here
end)
```

Now, before we program the actual function, we will program a few conditions that will terminate the function immediately, since these cases are not relevant to the role. 

For this purpose we use so-called "if-statements". This can be used to create function blocks that are only called if the associated condition has been met. If you already have some experience, you can first try to define both conditions yourself. If you have problems or can't do that yet, you can scroll down further. The first condition is to prevent that the victim is also a tester. If the victim is a tester, the function should be terminated immediately. The other condition is to terminate the function if the victim is not a traitor. After all, we only want to heal the tester if the person who died was really a traitor colleague.

```lua
    if victim:GetSubRole() == ROLE_TESTER and victim:GetTeam() ~= TEAM_TRAITOR then return end

``` 
Before we go any further, let's try to understand these statements now.

Basically the line means "If the victim is tester as subrole and the victim is not a member of the traitor team, then terminate the function (then return end)". At this point it is important to access the subrole. If the base role were accessed, the tester would be a traitor. It is also important to access the Traitor Team and not the Traitor role, as we want to include other Traitor roles, such as the Vampire, for the function.

With these conditions, we can ensure that the subsequent code is called only if the victim belonging to the hook is a Traitor colleague.

Next we want to store all players in variable. We do this by typing `local plys = player.GetAll()`. As a result, we can now access all players via the variable "plys".
Now we have to sort out all the players who do not match what we need and when we have found a player who meets our conditions, perform the corresponding function. We can achieve this by using a "for-loop".
You initialize a for-loop with the following code:

`for i=1, #plys do`

With this, we basically iterate through each player and check them, for the following conditions.
So next we need a variable that represents the player we are currently checking. we do this by adding the following line:

`local ply = plys[i]`

Now when we access “ply”, we thereby access the player we are checking in the current iteration.
Next, we want to write a condition that will only be met if the current player is alive and has the role Tester. Feel free to try developing this condition yourself. You can also use the GMOD Wiki if you get stuck. Otherwise you can scroll further and examine the solution.

`if ply:GetSubRole() == ROLE_TESTER and ply:Alive() then`

Next, we use an "if-else statement". Else is used for blocks of code that will be executed instead if the If-statement has not been met.
With this block we develop the actual function of the role. This statement will define what happens to the tester himself when one of his traitor colleagues has actually died.

Just a reminder of what is supposed to happen: If a fellow traitor dies, the tester's HP should be set to 200 HP if they have 100 or more HP, or set to 125 HP if they have less than 100 HP. 
First try to develop this block yourself. Once again: Use the GMOD Wiki if there is something unclear. As a little help, I'll show you how to create an if-else nest. If you get stuck, you can scroll down to see the solution:

```lua
    if [FIRST CONDITION HERE] then

        --[CODE TO PROCESS HERE]

    else 

        --[CODE TO PROCESS HERE]

    end
```

Once you have set the first condition, due to the else you don't have to develop the second one, because the else will then cover all other cases for you. When you're done, save and test out the role in Garry's mod to see if everything works as planned.

If you did everything right, the code should look something like this:

```lua
    -- is the player's health beneath 100, he gains an amount of hp
    if ply:Health() < ply:GetMaxHealth() then

	      ply:SetHealth(125)

    else	 -- is the player's health above 100, he gains another amount of hp

	      ply:SetHealth(200)

    end
```

To get a better overview, here I have the whole hook for you:

```lua
if SERVER then
	
	hook.Add("PlayerDeath", "ttt2_heal_up_tester", function( victim, inflictor, attacker)
		if victim:GetSubRole() == ROLE_TESTER then return end
		if SpecDM and (victim.IsGhost() and victim:IsGhost()) then return end
		if victim:GetTeam() ~= TEAM_TRAITOR then return end
		
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			if ply:GetSubRole() == ROLE_TESTER and ply:Alive() and ply:IsActive() then

				-- is the player's health beneath 100, he gains an amount of hp
				if ply:Health() < ply:GetMaxHealth() then

					ply:SetHealth(125)

				else	 -- is the player's health above 100, he gains another amount of hp

					ply:SetHealth(200)

				end
			end
		end	
	end)
end
```

And that's basically it. You have now created a working Traitor role. However, the role is now hard-coded. It cannot be flexibly adjusted in various places and, above all, the user has little control over the settings of the role without having to program it himself. For this reason I will go into a few optional details that you should definitely take into account in the following chapter. It will contain some tips and at the end the whole code to follow. Please note that this code contains the optional improvements.

## Optionals

### Optimizing the tester

In this section we want to optimize the tester in 2 more places. I would like to introduce you to 2 constructs that you will also frequently encounter and use. On the one hand the net library and on the other hand ConVars. For the latter you might have already created folders in the chapter about folder structure. If not, go back there, do that and come back here when you are done.

#### The net library

But before we take care of the ConVars, we first include the net library. We use this to send data back and forth between the server and the client. Perhaps you can see, the net library is something, you will need many times in the future cecause there is always data to be exchanged between client and server. Especially when developing addons for a multiplayer game, like Garry's mod respectively in our case TTT2 is.

I will show you the net library with a specific example, but the net library can do much more and is also much more complex. For this reason I still recommend you to read and understand the [corresponding wiki article](https://wiki.facepunch.com/gmod/Net_Library_Usage).

To explain the use of the net library with an example, we will implement the following: When a traitor dies and the tester is healed, a message is sent to all players symbolizing this.

For this, 3 steps must be taken:
1. The server must prepare the packet that contains the data that needs to be sent.
2. The server must send the data packet as soon as the tester is cured.
3. The client receives the package, displays the containing Data to the user.
For the first step, we add the package to the first server code block. I'll show you what I mean by presenting the first block and its solution:

```lua
    if SERVER then
        AddCSLuaFile()

        util.AddNetworkString("ttt2_test_role_popup")
    end
```

`ttt2_test_role_popup` is not the message to be sent, but the identifier for the data package. To prevent overwriting, a unique name should again be chosen here.

With this, we have already completed the first step and can move on to the 2nd one.
To send the packet at the right time we need to edit the if-else block.
Again, I will first present the corresponding code and then explain it:


```lua
-- is the player's health beneath 100, he gains an amount of hp
if ply:Health() < ply:GetMaxHealth() then

	ply:SetHealth(200)
	net.Start("ttt2_test_role_popup")
	net.Broadcast()
					

else	 -- is the player's health above 100, he gains another amount of hp

	ply:SetHealth(125)
	net.Start("ttt2_test_role_popup")
	net.Broadcast()
					
end
```

With `net.Start(“ttt2_test_role_popup”)` we can tell the server to send out the package to the Clients. With the use of `net.Broadcast()` the packet is sent to all clients.

Finally, the client must process the packet and display the data from it on the user's screen.
For this we go to the very end of the file and add an extra code block:

```lua
if CLIENT then
	net.Receive("ttt2_test_role_popup", function()
		EPOP:AddMessage({text = LANG.GetTranslation("ttt2_role_tester_epop"), color = TESTER.ltcolor}, "", 10)
	end)
end
```

Since we work client-side, there must be no `if SERVER then` here. With `net.Receive()` the client receives the corresponding packet - it can recognize this by the identifier - and executes the function to display the message. 
To display the message I used a so called [EPOP](https://api-docs.ttt2.neoxult.de/class/EPOP/none). This does not come from Garry's mod itself, but from TTT2 and can therefore only be used in TTT2. As you may have seen, I didn't insert any text there, but instead `LANG.GetTranslation("ttt2_role_tester_epop")`. This makes code even more flexible to translate. With this command I put a corresponding text in the lang file. Instead of displaying a static text, the corresponding sentence from the lang file is displayed instead, in the corresponding language that the user uses when the text is translated:

```lua
L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[TESTER.name] = "Tester"
L["info_popup_" .. TESTER.name] = [[You are the Tester!
If If one of your Traitor colleagues dies, your HP increases by a certain value.]]
L["body_found_" .. TESTER.abbr] = "They were a Tester."
L["search_role_" .. TESTER.abbr] = "This person was a Tester!"
L["target_" .. TESTER.name] = "Tester"
L["ttt2_desc_" .. TESTER.name] = [[The Tester needs to win with the traitors!]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_role_tester_epop"] = "While some lose strength, others gain new strength!"
```

For the displayed color, we use the color code of the roll here, but in a slightly lighter form. This is described by means of `color = TESTER.ltcolor`. 
If we now execute the role in the game, we can see the text when healing.

#### The integration of ConVars

We have already explained what ConVars are. Even if I explain this aspect here under the optional things, you should definitely use some when programming your roles. After all, they give the user the possibility to customize the role according to their own wishes.
We will develop 3 ConVars as an example: 2 of them control the HPs set when the tester's HP is both above and below 100 when healing.
The third one lets the user decide whether to have the EPOP displayed or not.
But before we can adjust the code accordingly, we need to create the ConVars. We could theoretically do this directly in "shared.lua" with the rest of the code. But if you ever develop a role that is a bit more complex, your code can get cluttered pretty quickly. For this reason we outsource the ConVar creation to a separate file.
Go here for that: 

`ttt2-role_test/lua/terrortown/autorun/shared/sh_tester_convars.lua`

Here you can create ConVars by doing this:

```lua
CreateConVar("ttt_tester_health_above_100", 200, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt_tester_health_beneath_100", 125, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt_tester_send_popup", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
```

The first placeholder is for the ConVar’s identifier. The second one’s the default value and the third one are the ConVar’s flags. Besides these 3 there are a number of flags, the whole list can be found in the [GMOD Wiki](https://wiki.facepunch.com/gmod/Enums/FCVAR).

With this, the ConVars are at least already created. If you use the TTT2 ULX plugin yourself or want to give users the possibility to use it for your role, you should add an appropriate hook to the file. This looks like this: 

```lua
hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_tester_convars", function(tbl)
    tbl[ROLE_TESTER] = tbl[ROLE_TESTER] or {}

    table.insert(tbl[ROLE_TESTER], {
        cvar = "ttt_tester_health_above_100",
		slider = true,
		min = 0,
		max = 500,
		decimal = 0,
		desc = "ttt_tester_health_above_100 (def. 200)"
	})

    table.insert(tbl[ROLE_TESTER], {
        cvar = "ttt_tester_health_beneath_100",
		slider = true,
		min = 0,
		max = 500,
		decimal = 0,
		desc = "ttt_tester_health_beneath_100 (def. 125)"
	})

    table.insert(tbl[ROLE_TESTER], {
		cvar = "ttt_tester_send_popup",
		checkbox = true,
		desc = "ttt_tester_send_popup (def. 1)"
	})
end)
```

There is no need to put this hook or the creation of the ConVars into a server-block (`if SERVER..then`).
In the table (tbl), which is passed as a parameter in the function, you must enter the name of your role. Then you add the previously created ConVars to the table itself using `table.insert`. If you use a checkbox for the ConVar, because the ConVar can only have 2 states (see: `ttt_tester_send_popup`), the possible arguments are smaller. Basically, the parameters to be set are actually self-explanatory.
Once you have completed this step as well, we can switch back to `shared.lua` and assign the ConVars their function.

Here we must now first prepare the ConVars. We do this by assigning a variable to each of them that contains the current value of the respective ConVar.
The best way to do this is to go into the "PlayerDeath" hook between the first 3 if-statements and `local plys = player.GetAll()`.
You can now try to figure out how to assign a variable to the ConVars yourself and again use the [GMOD Wiki](https://wiki.facepunch.com/gmod/) for help. Alternatively you can have a look at the solution and try to understand it:

```lua
-- cache ConVar values
local hp_above = GetConVar("ttt_tester_health_above_100"):GetInt()
local hp_below = GetConVar("ttt_tester_health_beneath_100"):GetInt()
local cv_send_popup = GetConVar("ttt_tester_send_popup"):GetBool()
```

By means of `GetConVar` we can get the data of the ConVar via its identifier. But this alone is not enough, because otherwise we would only get the information data of the corresponding ConVars, but we want to have the values of these. 
Therefore we have to write `GetInt()` after `GetConVar` if we have a numerical value (Integer) or `GetBool()` if we have a state value (Boolean; true or false; 1 or 0).
Now we can use the created variables for the ConVars instead of always having to check the ConVars themselves.
To implement the variables "hp_below" and "hp_above" it doesn't take much. Just go to the lines `ply:SetHealth(125/200)` and replace the numbers in the brackets with the names of the variables. Lua will then automatically know itself which values to enter for them.

Now to implement the Boolean we need an if statement, because with this we can query the current state of the Boolean.
If the Boolean is set to False, i.e. we do not want the EPOP to be displayed, we must prevent the net library packet from being sent. To do this, in the "if-else block" go to the two lines `net.Start()` and `net.Broadcast` respectively. Now add each of these to an if-statement that checks the ConVar Boolean. You do this as follows:

```lua
    -- if convar is set, players receive the pop-up
    if cv_send_popup then
	      net.Start("ttt2_test_role_popup")
	      net.Broadcast()
    end
```

The if-statement means: "If the variable cv_send_popup is true, then send the packet".

In the last chapter you can see and understand the whole code yourself. But before we get to that, I'd like to give you a few tips along the way.

### General tips

#### Use the comments function

You may have already seen it with my code now and then. If you write "-- text here", then the following text in the line is recognized as comment and not executable code. Use this option. Both for yourself and for others. Even if you know exactly what your code does, comments can be helpful. For example, if you are on vacation for 3 weeks, come back and want to continue developing, the comments will help you find your way around your code. Also, if others are developing on your code at some point, they can find their way around better.

#### Indent your code

If you use a proper development environment, it already helps you automatically. However, you should always make sure to indent the code yourself. This is the only way to better understand connections in case of errors. If you have positioned everything directly at the beginning of a line, you may no longer be able to understand what belongs to the faulty if-statement and what does not.

#### Don't be afraid to use the GMOD Wiki

Garry's Mod Wiki is nothing but a huge database that holds a lot of commands and knowledge that can simplify your development. You don't know how to change HUD elements? Check out the wiki. "What was that about the net library again?" The GMOD Wiki knows the answer. Knowledge is power and the wiki has plenty of it. I don't know any Garrys Mod developer who hasn't used the wiki at least once themselves.

#### Publish your code on GitHub

Using GitHub is also extremely beneficial. What happens, for example, if you are in the exam phase at university, have no time to program yourself and an update is released that makes your code unusable? 
Once you have made your code available on GitHub, other developers can work on a patch and make it available to you via a pull request. You can then make the code functional again with just a few clicks. In terms of role development, GitHub also allows translators to translate your scripts into other languages without you having to worry about it.

## The Tester's Code

To see the tester's code you can open my GitHub repository [here](https://github.com/Pythagorion/ttt2-role_test). Besides the code, you can also see the folder structure there, in case something is unclear.
