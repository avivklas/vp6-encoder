FROM		ubuntu:16.04
MAINTAINER  Aviv Klasquin Komissar <avivklas@gmail.com>

WORKDIR		/usr/local/src

RUN		    apt-get update && apt-get install -y \
			    software-properties-common \
			    python-software-properties

RUN		    add-apt-repository ppa:ubuntu-wine/ppa

RUN		    dpkg --add-architecture i386

RUN         echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

RUN		    apt-get update && apt-get install -y \
			    p7zip-full \
			    wine1.8 \
			    winetricks

RUN         wineboot -i

RUN		    mkdir /usr/lib/codecs

RUN		    wget http://mplayerhq.hu/MPlayer/releases/codecs/windows-essential-20071007.zip \
			    && unzip windows-essential-20071007.zip \
			    && cp windows-essential-20071007/* /usr/lib/codecs/

RUN		    wget -O MPlayer-generic.7za http://downloads.sourceforge.net/project/mplayer-win32/MPlayer%20and%20MEncoder/r38116+gf4cf6ba8c9/MPlayer-generic-r38116+gf4cf6ba8c9.7z \
			    && 7za x MPlayer-generic.7za

RUN		    mv MPlayer-generic-r38116+gf4cf6ba8c9 /var/opt/MPlayer

COPY		vp6conf /usr/lib/vp6conf

COPY		run.sh /var/opt/tools/

ENTRYPOINT	["/var/opt/tools/run.sh"]
CMD         ["-h"]
