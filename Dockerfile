FROM ubuntu:17.10
MAINTAINER tim@chaubet.be
LABEL docker-ptmagic.version="1.5.1"
ADD VERSION .

ENV TZ 'Europe/Brussels'
ENV PG_VERSION 1.5.1
# to be fixed: the zip is pulled in the dockerfile. changing the version won't change the zipfile from the default.

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && echo $TZ > /etc/timezone \
 && rm /etc/localtime \
 && apt-get dist-upgrade -y \
 && apt-get install -y net-tools \
                       iputils-ping \
                       curl \
                       wget \
                       unzip \
                       tzdata \
 && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
 && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
 && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-artful-prod artful main" > /etc/apt/sources.list.d/dotnetdev.list' \
 && apt-get update 
 
RUN wget -q packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/17.10/packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb
 
#RUN apt-get install -y dotnet-sdk-2.1.3 \
#                       aspnetcore-store-2.0.6 \

RUN mkdir -p /opt/pt-magic/ptm-binance 
 && cd /opt/pt-magic/ptm-binance \
 && wget https://github.com/Legedric/ptmagic/releases/download/$PG_VERSION/PTMagic.$PG_VERSION.zip \
 && unzip *.zip \
 && mv PTMagic\ $PG_VERSION/* . \
 && mv PTMagic/* . \
 && rm *.zip \
 && ls -hl \
 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && dpkg-reconfigure -f noninteractive tzdata \
 && apt-get clean

VOLUME ["/mnt/profittrailer","/mnt/ptmagic"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["PTMagic.dll"]
