# Shell Remote Manager

Manage your SSH connections to groups and connect easily + choose to run SSH or Midnight Commander.

<pre>
<b>$</b> devel
===========================================
 - <b>example</b>: example.cz
 - <b>home</b>: example.cz
 - <b>server</b>: example.cz
===========================================

example
Connecting... <b>example@example.cz</b>
...
ssh<b>$</b> exit
...
Closed... <b>example@example.cz</b>
</pre>

## License
Project is under Do What the Fuck You Want to Public License v2 (WTFPL-2.0).

## Requirements
- Midnight Commander

## Install

```Bash
# Clone git repository to ~/.remote-manager/
$ git clone https://github.com/MHMcz/remote-manager.git ~/.remote-manager

# copy config file
$ cd ~/.remote-manager/
$ cp config.dist config

# edit new config file

# link run.sh to you "bin" directory with name you prefer for list identify (sample below choose "devel")
$ ln -s ~/.remote-manager/run.sh ~/bin/devel # or /usr/local/bin/devel or ...

# create config file with same name
$ cp example.cfg devel.cfg
$ chmod 600 devel.cfg # not required, but better

# edit devel.cfg file and create your own list of remotes

# link run.sh to you "bin" directory with same name + MD_POSTFIX from config file
$ ln -s ~/.remote-manager/run.sh ~/bin/develcp # or /usr/local/bin/develcp or ...

# now you can run application
$ devel # or develcp
...
````

## Configure

- `~/.remote-manager/config`
  - `DEFAULT_LOCAL_DIR` = default local direcotry when start Midnight Commander
  - `MC_POSTFIX` = postfix in links to script, when you want run Midnight Commander instead of SSH

- `~/.remote-manager/*.cfg`
  - files for links - every link to script has own config file with same name
  - file format is `alias;user@server;ssh_params`, one in line

## Usage
Sample usage when:
- you have created link to your bin dir (for example "devel")
- you have created config in `~/.remote-manager/` (same name: `devel.cfg`), below is example with 3 servers

```
$ devel
===========================================
 - example: example.cz
 - home: example.cz
 - server: example.cz
===========================================

example
Connecting... example@example.cz
...
ssh$ exit
...
Closed... example@example.cz
```

You can run short version (when you remember alias from config)
```
$ devel example
Connecting... example@example.cz
...
ssh$ exit
...
Closed... example@example.cz
```

Similar to run Midnight Commander instead of SSH
- `MC_POSTFIX="cp"`
- link to your bin dir (for example "develcp")
```
$ develcp example
Connecting... example@example.cz
...
#Midnight Commander is running and F10 to exit
...
Closed... example@example.cz
```