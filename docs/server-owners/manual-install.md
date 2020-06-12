# Setting up a dedicated Linux Server (for TTT2)

This is a Guide for the most 'manual' install you can do. If you want a more automated setup, parts of this guide may still apply but you could give something like [LinuxGSM](https://linuxgsm.com/lgsm/gmodserver/) a look.

??? quote "Reference Guides from Gmod Wiki and Valve Wiki"
    - [Downloading SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)
    - [Downloading Game Content (e.g. CSS, TF2)](https://wiki.facepunch.com/gmod/Downloading_Game_Content_to_a_Dedicated_Server)
    - [Mounting Game Content](https://wiki.facepunch.com/gmod/Mounting_Content_on_a_Dedicated_Server)
    - [Linux Dedicated Server Hosting](https://wiki.facepunch.com/gmod/Linux_Dedicated_Server_Hosting)
    - [Steam Game Server Accounts](https://wiki.facepunch.com/gmod/Steam_Game_Server_Accounts)
    - [Workshop Collection for Dedicated Servers](https://wiki.facepunch.com/gmod/Workshop_for_Dedicated_Servers)
    - [Known Issues](https://developer.valvesoftware.com/wiki/SteamCMD#Known_issues)

## Prerequisites

### Hardware Specifications

RAM, networkspeeds, storagespace and cpu-clock requirements heavily depend on different factors e.g. playercount, addons and so forth. Therefore i can't really give an estimate on what exactly you need. As for CPU-Cores: Garrysmod Dedicated Server will mostly only use one core or rather one thread.

Also note ARM-based CPUs won't work (e.g. RaspberryPi).

??? "Specs of my test-systems (just for reference):"

    ```
    CPU: 2 logical Cores @2.1Ghz x86_64
    RAM: 4Gb DDR3 (ECC non-buffered 1333Mhz)
    Storage: 32Gb HDD
    Network: 100/30 MBit down/up
    OS: Ubuntu-18.04 64-Bit
    ```

    ```
    CPU: 1 logical Core @3.5Ghz x86_64
    RAM: 4Gb DDR3 (ECC non-buffered 1333Mhz)
    Storage: 32Gb HDD
    Network: 100/30 MBit down/up
    OS: Ubuntu-20.04 64-Bit
    ```

    ```
    CPU: 4 logical Cores @1,5Ghz x86_64
    RAM: 8Gb DDR3 (non-ECC 1333Mhz)
    Storage: 60Gb SSD
    Network: 100/30 MBit down/up
    OS: Fedora32 64-Bit
    ```

### Software Packages

There are some packages we will need. You can get them by running the following command with root privileges:

=== "Debian/Ubuntu"

    ```bash
    apt install lib32gcc1 lib32stdc++6 lib32tinfo5 wget
    ```

=== "RedHat/CentOS"

    !!! warning
        These should be the right packages, but I did not test them.

        ```bash
        yum install glibc.i686 libstdc++.i686 ncurses-compat-libs.686 wget
        ```

=== "Fedora"

    ```bash
    dnf install glibc.i686 libstdc++.i686 ncurses-compat-libs.i686 wget
    ```

!!! note

    Optional package to install: `tmux` -> can be used in the [startscripts](#setup-start-and-updatescripts) section.

### Server User Setup

We don't want our Garrysmod server to run as root or as our sudo user, so we will create a new unprivileged user (in this case named `steam`):

```bash
sudo useradd -m steam
```

All commands from now on will be run by that user, there are two ways you can switch to that user:

=== "Variant 1"

    Don't set a password and use your root privileges to switch to that user:

    ```bash
    sudo su steam
    ```

    In my case the default shell was `/bin/sh` which I was having issues with, so I changed to the `/bin/bash` shell by simply typing it and pressing enter:

    ```sh
    /bin/bash
    ```

    ??? note "Set the default login shell"
        If you don't want to change the shell everytime you login to the `steam` user simply execute the following command with your priviliged user:
        ```bash
        sudo usermod --shell /bin/bash steam
        ```

=== "Variant 2"

    Run the following command and follow the instructions to set a password:

    ```bash
    sudo passwd steam
    ```

    From now on you can directly login to that user with the name and password. As we are already logged in, we will simply switch users: 

    ```bash
    su steam
    ```

    In my case the default shell was `/bin/sh` which I was having issues with, so I changed to the `/bin/bash` shell by simply typing it and pressing enter:

    ```sh
    /bin/bash
    ```

    ??? note "Set the default login shell"
        If you don't want to change the shell everytime you login to the `steam` user simply execute the following command with the `steam` user:
        ```bash
        chsh -s /bin/bash
        ```

### Things to look out for

- Don't use Capital Letters in any directory or filename
- If you intend to host this server at home, keep in mind you would need to open some ports to the internet. Setting that up and securing this is out of the scope of this guide (at least for now)
- TTT2 is intended to be used as a 'normal' Addon **do not** overwrite any garrysmod files with it
- Instead of using FastDL use a [workshop-downloader addon](https://steamcommunity.com/sharedfiles/filedetails/?id=626604673). With FastDL you invest a lot of time just to get weird issues. It is just not worth it
- safely shutdown your server with `quit` in the serverconsole. ULX won't save your conVars otherwise.

## SteamCMD

### Install SteamCMD

SteamCMD is the software used to install serverfiles for dedicated servers. We will need it to install the Garrysmod and Counterstrike:Source files.

With the following four commands we will create a directory for our SteamCMD installation and download it:

```bash
mkdir ~/steam # create the 'steam' directory in the home directory
cd ~/steam # go to the steam directory
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz # download the compressed steamcmd files
tar -xvzf steamcmd_linux.tar.gz # uncompress the files
```

Now you can start SteamCMD with the following command (it will install/update itself):

```bash
./steamcmd.sh # execute the steamcmd script
```

### Install Gmod and CSS

After the last command you should now have a shell that looks like this:

```steamcmd
Steam>
```

The Garrysmod and Counterstrike:Source serverfiles do not require an account that owns the game, so we will login anonymously:

```steamcmd
login anonymous
```

Before we install something we can (and should) specify a directory where the files should be installed:

```steamcmd
force_install_dir /home/steam/gmod_ds/
```

After that we can install/update:

```steamcmd
app_update 4020 -validate
```

!!! tip
    You will need to use these commands everytime you want/need to update your server installation.

Now we need the same commands slightly modified for the CSS files:

```steamcmd
force_install_dir /home/steam/css_ds/
app_update 232330 -validate
```

This is all we need to do with SteamCMD so we can now quit it:

```steamcmd
quit
```

## Basic Configuration

Now we have everything installed that we need, but before we start the server for the first time we should do some basic configuration to ensure everything goes well.

### Mount Counterstrike:Source

Many weapons and maps for TTT need Counterstrike:Source mounted to function properly. This is the reason we also downloaded CSS earlier.
To mount the game files into Garrysmod you need to head to the `mount.cfg` file and edit it with an editor of your choice (I will be using nano):

```bash
nano ~/gmod_ds/garrysmod/cfg/mount.cfg
```

The file will look something like this:

```cfg
//
// Use this file to mount additional paths to the filesystem
// DO NOT add a slash to the end of the filename
//

"mountcfg"
{
    //"cstrike"     "C:\mycssserver\cstrike"
    //"tf"          "C:\mytf2server\tf"
}
```

Simply remove the `//` from the `"cstrike"` and change the path according to the CSS Installation path. Now your file should look like this:

```cfg
//
// Use this file to mount additional paths to the filesystem
// DO NOT add a slash to the end of the filename
//

"mountcfg"
{
    "cstrike"     "/home/steam/css_ds/cstrike"
    //"tf"          "C:\mytf2server\tf"
}
```

Save the file and then quit out of the editor.

!!! info
    For nano you do that with ++ctrl+s++ and then ++ctrl+x++.

Now CSS will be mounted when you start your Gmod server.

### Server.cfg / Autoexec.cfg

These two files are primarily used to configurate your server as they are executed automatically.
!!! info
    They are located at `/home/steam/gmod_ds/garrysmod/cfg/`.  
    `autoexec.cfg` is executed everytime the server starts.  
    `server.cfg` is executed everytime a mapchange occurs.

    !!! tip
        If you don't know where to put which configuration or if you only want to manage one `.cfg` file just use the `server.cfg`.

!!! example "A minimal .cfg file could look like this:"
    ```cfg
    hostname "My Garrysmod Server"
    sv_password ""
    sv_allowdownload 0
    sv_allowupload 0
    sv_timeout 60

    log on
    sv_logbans 1
    sv_logecho 0
    sv_logfile 1
    sv_log_onefile 0

    sv_minrate 0
    sv_maxrate 20000
    sv_maxupdaterate 66
    sv_minupdaterate 10

    //execute ban files
    exec banned_ip.cfg
    exec banned_user.cfg
    ```

If you don't want random people connecting set `sv_password` to something.

??? tip "Explanation of Commands and more"
    Coming soon!

You can also set TTT ConVars in these files, but I would instead [use ULX](#ulx) so you can reconfigure and save settings on the fly from inside the game.

### Start your Garrysmod Server

You can now start your server with the following command:

```bash
~/gmod_ds/srcds_run -game garrysmod +gamemode terrortown +maxplayers 16 +map gm_flatgrass
```

### Host a Workshop Collection

Simply create a Workshop Collection on the Steam Workshop or choose an [existing one](https://steamcommunity.com/workshop/browse/?appid=4000&section=collections).
If you choose to create your own collection, keep in mind it has to be public or unlisted for the server to see it.
(I'll be using [this collection](https://steamcommunity.com/sharedfiles/filedetails/?id=2052244154))
Next you need to get the ID of that collection and add it to your server start command:

```bash
~/gmod_ds/srcds_run -game garrysmod +gamemode terrortown +maxplayers 16 +map gm_flatgrass +host_workshop_collection 2052244154
```

??? question "Find the ID of a collection or Addon"
    You can find the ID of any Workshop Addon/Collection at the end of the URL.
    [https://steamcommunity.com/sharedfiles/filedetails/?id=**2052244154**](https://steamcommunity.com/sharedfiles/filedetails/?id=2052244154)

### ULX

I highly suggest using ULX as it makes many things easier. You will need [ULX](https://steamcommunity.com/sharedfiles/filedetails/?id=557962238), [ULib](https://steamcommunity.com/sharedfiles/filedetails/?id=557962280) and [ULX Commands for TTT2](https://steamcommunity.com/sharedfiles/filedetails/?id=1362430347).

!!! tip
    These 3 addons are already inside the collection I'm using in the example. If you are making your own collection don't forget to add those 3!

Set yourself as superadmin so you can change the server settings. Just be connected to the server and type the following into the serverconsole. Replace "your username" with your steamname!

!!! info
    The `""` are only needed if your steamname contains whitespaces.

```console
adduser "your username" superadmin
```

## Further Configuration

### Use a Steam Game Server Account

Go to this [Steam Page](https://steamcommunity.com/dev/managegameservers) make sure you match the account requirements and then create a game server account.

Starting with the Garry's Mod May 2020 update, servers without a game server account will experience a low ranking in the serverbrowser.

Also keep in mind each game server account is only useable by one server instance at a time. You can't use one account on multiple server instances simultaneously.

You will need to enter two things:

- The App ID of the base game this is `4000` for Garry's Mod (DO NOT use `4020` here)
- a memo to remember what server the game account is for

Now to use the account with your server simply add `+sv_setsteamaccount` followed by the generated token to your startcommand, like so:

```bash
~/gmod_ds/srcds_run -game garrysmod +gamemode terrortown +maxplayers 16 +map gm_flatgrass +host_workshop_collection 2052244154 +sv_setsteamaccount WHATEVERYOURTOKENIS
```

!!! note

    Tokens will expire if you don't use them for a long time. In that case just visit the [Steam Page](https://steamcommunity.com/dev/managegameservers) again, regenerate the token and update your startcommand to use the regenerated token.

### Setup Start- and Updatescripts

You most likely don't want to type your whole startupcommand everytime you want to start your server. So we will create a directory in which we will place various scripts.

You can call this directory whatever you like, i simply called mine `startscripts`:

```bash
mkdir ~/startscripts/ # create the directory
cd ~/startscripts/ # move inside the created directory
```

Open a new script file:

```bash
nano ttt2_server.sh
```

The minimal script will only be the startcommand from earlier, the advanced script uses `tmux` to put the serverconsole in another terminal.

!!! example "Minimal Script"

    ```bash
    ~/gmod_ds/srcds_run -game garrysmod +gamemode terrortown +maxplayers 16 +map gm_flatgrass +host_workshop_collection 2052244154 +sv_setsteamaccount WHATEVERYOURTOKENIS
    ```

??? example "'Advanced' Script"

    ```bash
    #!/bin/bash

    echo "Starting Histalek's TTT2 Server. Connect to the serverconsole with 'tmux a -t ttt2'!"
    tmux new -d -s ttt2 '~/gmod_ds/srcds_run -game garrysmod +gamemode terrortown +maxplayers 16 +map gm_flatgrass +host_workshop_collection 2052244154 +sv_setsteamaccount WHATEVERYOURTOKENIS'
    ```

    The first line simply prints the string into your console to remind you which command lets you connect to the serverconsole, because the second line will start the server in the background.

Now we need to make the script executable for our user:

```bash
chmod u+x ttt2_server.sh
```

To start the server you can now type:

```bash
./ttt2_server.sh
```

### Steamclient.so Fix

!!! note
    If you do not spot an error message regarding `steamclient.so` you will not need to do this.  
    If you see `[S_API] SteamAPI_Init(): Loaded 'steamclient.so' OK.` you are fine.

The gameserver looks for the steamclient in a specific location where it is not installed to by default. We fix this by creating the directory and using a symlink:

```bash
mkdir -p ~/.steam/sdk32
ln -s ~/steam/linux32/steamclient.so ~/.steam/sdk32/steamclient.so
```

### Add Addons from outside the Workshop

All directories (and their contained files) in the `/home/steam/gmod_ds/garrysmod/addons/` directory will be mounted as 'filesystem addons'.
This however is not recommended as this could cause some issues. Only do this if you have a good reason for it (e.g. Addon not on the Workshop, modificated Addon).
The biggest problem with this is the clients who join the Server need to get these files somehow.

This means either:

- the clients have to download the files directly from the server
  - which you would need to allow in the `server.cfg` with `sv_allowdownload 1`
  - which takes up serverressources (CPU-time and bandwidth mostly)  
- you would need to setup 'FastDL'
  - not recommended as it is a hassle to setup and brings another level of potential issues

### Use the Garrysmod 64-Bit Version

!!! warning
    If you follow these steps you will switch to an experimental build of the gameserver. Bugs are to be expected.

We will do the exact same thing as in the [Install Gmod](#install-gmod-and-css) section, but instead of

```steamcmd
app_update 4020 validate
```

we will do

```steamcmd
app_update 4020 -beta x86-64 validate
```

this will download the **experimental** branch of Gmod which features a 64-Bit Version of the server executable which will be in `/home/steam/gmod_ds/garrysmod/` and is called `srcds_run_x64`.

!!! note
    The 32-Bit version `srcds_run` is also still available, but as this is an experimental **beta** it might be different to the non beta branch executable. Just keep this in mind if you encounter issues.

    Also keep in mind that your startscripts will reference the 32-Bit version, so you would need update them accordingly. Or better make a copy of them and only change the copy.

To go back to the stable Gmod release redo the [Install Gmod](#install-gmod-and-css) steps and exchange the `app_update` command with:

```steamcmd
app_update 4020 -beta NONE validate
```
