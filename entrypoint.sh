#!/bin/bash

## treat env vars

## hand of to CMD

echo "Copying ProfitTrailer's trading configuration to PTM as base..."
cp /mnt/profittrailer/trading/* /opt/pt-magic/ptm-binance/_presets/Default/
if [ ! -f /mnt/ptmagic/settings.analyzer.json ]; then
  cp -r /opt/pt-magic/ptm-binance/_default\ settings\ BTC\ or\ ETH/* /mnt/ptmagic/
fi
ln -s /mnt/ptmagic/Monitor /opt/pt-magic/ptm-binance/Monitor
ln -s /mnt/ptmagic/settings.analyzer.json /opt/pt-magic/ptm-binance/settings.analyzer.json
ln -s /mnt/ptmagic/settings.general.json /opt/pt-magic/ptm-binance/settings.general.json
ln -s /mnt/ptmagic/nlog.config /opt/pt-magic/ptm-binance/nlog.config

# && cp -r '_default settings BTC or ETH'/* ./
ping 10.10.0.1 >/dev/null 2>/dev/null
