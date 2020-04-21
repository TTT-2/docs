# Setting up a dedicated Linux Server (for TTT2)

This is a Guide for the most 'manual' install you can do. If you want a more automated setup, parts of this guide may still apply but you could give something like [LinuxGSM](https://linuxgsm.com/lgsm/gmodserver/) a look.

## Reference Guides from Gmod Wiki and Valve Wiki

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

Specs of my test-system (just for reference):

```
CPU: 2 logical Cores @2.1Ghz x86_64
RAM: 4Gb DDR3 (ECC non-buffered 1333Mhz)
Storage: 32Gb HDD
Network: 100/30 MBit up/down
OS: Ubuntu-18.04 64-Bit
```

### Software Packages

There are some packages we will need. You can get them running the following command with root privileges:

=== "Debian/Ubuntu"

    ```bash
    apt install lib32gcc1 lib32stdc++6 lib32tinfo5 wget screen
    ```

=== "RedHat/CentOS"

    !!! warning
        These should be the right packages, but I did not test them.

        ```bash
        yum install glibc.i686 libstdc++.i686 ncurses-compat-libs wget screen 
        ```

=== "Fedora"

    !!! warning
        These should be the right packages, but I did not test them.

        ```bash
        dnf install glibc.i686 libstdc++.i686 ncurses-compat-libs wget screen 
        ```

### Server User Setup

We don't want our Garrysmod server to run as root or as our sudo user, so we will create a new unpriviliged user (in this case named `steam`):

```bash
sudo useradd -m steam
```

All commands from now on will be run by that user, so we need to switch to it:

```bash
sudo su steam
```

You can also set a password for that user and login directly afterwards:

```bash
sudo passwd steam
su steam
```

### Things to look out for

- Don't use Capital Letters in any directory or filename.
- If you intend to host this server at home, keep in mind you would need to open some ports to the internet. Setting that up and securing this is out of the scope of this guide (at least for now).
- TTT2 is intended to be used as a 'normal' Addon **do not** overwrite any garrysmod files with it
- Instead of using FastDL use a [workshop-downloader addon](https://steamcommunity.com/sharedfiles/filedetails/?id=626604673). With FastDL you invest a lot of time just to get weird issues. It is just not worth it

## SteamCMD

### Install SteamCMD

SteamCMD is the software used to install serverfiles for dedicated servers. We will need it to install the Garrysmod and Counterstrike:Source files.

With the following four commands we will create a directory for our SteamCMD installation and download it:

```bash
mkdir ~/steam
cd ~/steam
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
```

Now you can start SteamCMD with the following command (it will install/update itself):

```bash
./steamcmd.sh
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

!!! note
    You will need the last two commands everytime you want/need to update your server installation.

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

Save the file and then quit out of the editor - for nano you do that with `CTRL+S` and then `CTRL+X`.
Now CSS will be mounted when you start your Gmod server.

### Server.cfg / Autoexec.cfg

These two files are primarily used to configurate your server as they are executed automatically. They are located at `/home/steam/gmod_ds/garrysmod/cfg/`. `autoexec.cfg` is executed everytime the server starts; `server.cfg` is executed everytime a mapchange occurs.

A minimal .cfg file could look like this:

```cfg
hostname "server name"
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

??? "Explanation of Commands and more"
    Coming soon!

You can also set TTT ConVars in these files, but I would instead use ULX so you can reconfigure and save settings on the fly from inside the game.

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

### ULX

I highly suggest using ULX as it makes many things easier. You will need [ULX](https://steamcommunity.com/sharedfiles/filedetails/?id=557962238), [ULib](https://steamcommunity.com/sharedfiles/filedetails/?id=557962280) and [ULX Commands for TTT2](https://steamcommunity.com/sharedfiles/filedetails/?id=1362430347).

!!! note
    These 3 addons are already inside the collection I'm using in the example. If you are making your own collection don't forget to add those 3!

Set yourself as superadmin so you can change the server settings. Just be connected to the server and type the following into the serverconsole. Replace "your username" with your steamname!

!!! note
    The `""` are only needed if your steamname contains whitespaces.

```console
adduser "your username" superadmin
```

## Further Configuration

### Steamclient.so Fix

The gameserver looks for the steamclient in a specific location where it is not installed to by default. We fix this by creating the directory and using a symlink:

```bash
mkdir -p ~/.steam/sdk32
ln -s ~/steam/linux32/steamclient.so ~/.steam/sdk32/steamclient.so
```

### Setup (multiple) Startscripts

??? "**Coming soon**"

### Create a Steam Game Server Account

??? "**Coming soon**"
    [reference](https://steamcommunity.com/dev/managegameservers)

### Use the Garrysmod 64-Bit Version

??? "**Coming soon**"
