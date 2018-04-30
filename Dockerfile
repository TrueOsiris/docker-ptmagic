FROM trueosiris/ubuntu-dotnet
MAINTAINER tim@chaubet.be
LABEL docker-ptmagic.version="1.6.1"
ADD VERSION .

ENV TZ 'Europe/Brussels'
ENV PG_VERSION 1.6.1
# to be fixed: the zip is pulled in the dockerfile. changing the version won't change the zipfile from the default.
                       
RUN mkdir -p /opt/pt-magic/ptm-binance \
 && cd /opt/pt-magic/ptm-binance \
 && wget https://github.com/Legedric/ptmagic/releases/download/$PG_VERSION/PTMagic.$PG_VERSION.zip \
 && unzip *.zip \
 && mv PTMagic\ $PG_VERSION/* . \
 && mv PTMagic/* . \
 && rm *.zip 

VOLUME ["/mnt/profittrailer","/mnt/ptmagic"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["PTMagic.dll"]
