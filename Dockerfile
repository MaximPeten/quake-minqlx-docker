FROM ubuntu:14.04

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y libc6:i386 libstdc++6:i386 wget software-properties-common lib32gcc1 lib32z1 lib32stdc++6 curl git unzip
RUN add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get update
RUN apt-get install -y python3.5 python3.5-dev python3-pip build-essential libzmq3-dev

RUN useradd -ms /bin/bash quake

RUN cd && cp -R .bashrc .profile /home/quake
WORKDIR /home/quake
RUN chown -R quake:quake /home/quake
USER quake
ENV HOME /home/quake
ENV USER quake

#steamcmd
RUN mkdir -p /home/quake/steam && cd /home/quake/steam \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

#quake live
RUN /home/quake/steam/steamcmd.sh +login anonymous +force_install_dir ./steamapps/common/qlds/ +app_update 349090 +quit
RUN ln -s "/home/quake/steam/steamapps/common/qlds" ql

#sources
USER root
COPY server.sh ql/
RUN chown quake:quake ql/server.sh
COPY server.cfg ql/baseq3/
RUN chown quake:quake ql/baseq3/server.cfg
COPY mappool_turboca.txt ql/baseq3/
RUN chown quake:quake ql/baseq3/mappool_turboca.txt
COPY turboca.factories ql/baseq3/scripts/
RUN chown -R quake:quake ql/baseq3/scripts
COPY access.txt .quakelive/27960/baseq3/
RUN chown -R quake:quake .quakelive


#minqlx
RUN cd ql && curl -sqL "https://github.com/MinoMino/minqlx/releases/download/v0.5.2/minqlx_v0.5.2.tar.gz" | tar -zxvf - && unzip minqlx.zip
COPY minqlx-plugins ql/minqlx-plugins
RUN python3.5 -m pip install -r ql/minqlx-plugins/requirements.txt

USER root
RUN chown -R quake:quake ql/
USER quake

EXPOSE 27960 28960

CMD ql/server.sh 0
