# docker PT Magic
Docker Container for the PTMagic plugin for profit trailer. 
### Version 1.6.1

## Prerequisites
- A running profittrailer (I use the docker container rafffael/profit-trailer) 
- Full profittrailer folder accessibility via the docker volume /mnt/profittrailer
- Set trading.logHistory = 9999 in ProfitTrailers application.properties

## Getting Started

When starting this PT Magic docker fresh, config files will be copied from "\_default\ settings\ BTC\ or\ ETH" to the /mnt/ptmagic volume.

To upgrade from another setup (\*nix, win) copy the following files to the /mnt/ptmagic volume:
- nlog.config
- settings.analyzer.json
- settings.general.json
- Monitor/appsettings.json to Monitor/appsettings.json
- settings.secure.json (optional for Monitor password, if not added, it will create a new file & you will have to set the pass) 

The ProfitTrailer root folder has to be mapped to /mnt/profittrailer via a volume
The PTMagic config files folder has to be mapped to /mnt/ptmagic

```bash
docker run -d \
   --name='ptmagic' \
   --net='bridge' \
   -e TZ="Europe/Paris" \
   -v '/mnt/user/docker/profittrailer/':'/mnt/profittrailer':'rw' \
   -v '/mnt/user/docker/ptmagic':'/mnt/ptmagic':'rw' \
   'trueosiris/ptmagic'
```

For the monitor, launch a second container & add ./Monitor/Monitor.dll
This container will not start until PT Magic has created its first result, so be patient.

```bash
docker run -d \
   --name='ptmagic-monitor' \
   --net='bridge' \
   -e TZ="Europe/Paris" \
   -v '/mnt/user/docker/profittrailer/':'/mnt/profittrailer':'rw' \
   -v '/mnt/user/docker/ptmagic':'/mnt/ptmagic':'rw' \
   'trueosiris/ptmagic' ./Monitor/Monitor.dll
```

## Extras
### Setup Telegram
Setup a Telegram bot so PTM can send Telegram messages. 

Start a chat with the @BotFather Telegram bot; \
Enter the command “/newbot”; \
Enter the name of the bot, e.g. “SomePTMagicBot”; \
Enter the username of the bot, e.g. “some_pt_magic_bot”; \
Now copy the bot token to use in the next section; \
Start a chat @chatidbot to get your Telegram chat id; \
Click the button “Start” at the bottom of the page. \
Copy and save the bot token and chat id, as we are going to need it in a later step.

## References
https://github.com/Legedric/ptmagic \
https://profittrailer.com/ \
http://nidkil.me/2018/02/19/pt-magic-setup-on-ubuntu-17-10
