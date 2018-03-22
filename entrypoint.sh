#!/bin/bash

echo "Copying ProfitTrailer's trading configuration to PTM as base"
cp /mnt/profittrailer/trading/* /opt/pt-magic/ptm-binance/_presets/Default/
if [ ! -f /mnt/ptmagic/settings.analyzer.json ]; then
  echo "no PTM settings found in /mnt/ptmagic"
  echo "Copying files from \"_default settings BTC or ETH\""
  cp -r /opt/pt-magic/ptm-binance/_default\ settings\ BTC\ or\ ETH/* /mnt/ptmagic/
fi
echo "Setting rw rights on files in /mnt/ptmagic"
chmod -R 666 /mnt/ptmagic/*
echo "Creating symlinks in /opt/pt-magic/ptm-binance/ ..."
echo "Creating symlink to /mnt/ptmagic/Monitor/appsettings.json"
ln -s /mnt/ptmagic/Monitor/appsettings.json /opt/pt-magic/ptm-binance/Monitor/appsettings.json
echo "Creating symlink to /mnt/ptmagic/settings.analyzer.json"
ln -s /mnt/ptmagic/settings.analyzer.json /opt/pt-magic/ptm-binance/settings.analyzer.json
echo "Creating symlink to /mnt/ptmagic/settings.general.json"
ln -s /mnt/ptmagic/settings.general.json /opt/pt-magic/ptm-binance/settings.general.json
echo "Creating symlink to /mnt/ptmagic/nlog.config"
ln -s /mnt/ptmagic/nlog.config /opt/pt-magic/ptm-binance/nlog.config


ping 10.10.0.1 >/dev/null 2>/dev/null
