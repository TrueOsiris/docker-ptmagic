# docker PT Magic
Docker Container for the PTMagic plugin for profit trailer. 

## References
https://github.com/Legedric/ptmagic \
https://profittrailer.com/ \
http://nidkil.me/2018/02/19/pt-magic-setup-on-ubuntu-17-10

## Assumptions
- A running profittrailer (I use the docker container rafffael/profit-trailer) 
- Full profittrailer folder accessibility via the docker volume /mnt/profittrailer
- Set trading.logHistory = 9999 in ProfitTrailers application.properties

## Optional
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
