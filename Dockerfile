FROM ubuntu:14.04

ENV STEAM_DIR /home/quake/Steam
ENV QLDS_DIR /home/quake/Steam/steamapps/common/qlds
ENV QUAKE_APP_ID 349090

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y libc6:i386 \
    libstdc++6:i386 \
    software-properties-common \
    lib32gcc1 \
    lib32z1 \
    lib32stdc++6 \
    wget \
    curl \
    git \
    unzip \
    python3.5 \
    python3.5-dev \
    python3-pip \
    build-essential \
    libzmq3-dev \
    && add-apt-repository ppa:fkrull/deadsnakes \
    && apt-get update

# Add quake user
RUN useradd -ms /bin/bash quake \
    && cd \
    && cp -R .bashrc .profile /home/quake \
    && chown -R quake:quake /home/quake
WORKDIR /home/quake
USER quake
ENV HOME /home/quake
ENV USER quake

# Install steamcmd
RUN mkdir -p ${STEAM_DIR} && cd ${STEAM_DIR} \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Install Quake Live
RUN ${STEAM_DIR}/steamcmd.sh +login anonymous +force_install_dir ./steamapps/common/qlds/ +app_update ${QUAKE_APP_ID} +quit

# Sources
USER root
COPY server.sh ${QLDS_DIR}/
COPY server.cfg ${QLDS_DIR}/baseq3/
COPY mappool_turboca.txt ${QLDS_DIR}/baseq3/
COPY turboca.factories ${QLDS_DIR}/baseq3/scripts/
COPY access.txt .quakelive/27960/baseq3/
RUN chown -R quake:quake ${QLDS_DIR}/ \
    && chown -R quake:quake .quakelive

# Install minqlx
RUN cd ${QLDS_DIR} && curl -sqL "https://github.com/MinoMino/minqlx/releases/download/v0.5.2/minqlx_v0.5.2.tar.gz" | tar -zxvf - \
    && unzip minqlx.zip \
    && rm minqlx.zip

COPY minqlx-plugins ${QLDS_DIR}/minqlx-plugins

RUN python3.5 -m pip install -r ${QLDS_DIR}/minqlx-plugins/requirements.txt
RUN chown -R quake:quake ${QLDS_DIR}/

EXPOSE 27960 28960
ENTRYPOINT exec ${QLDS_DIR}/server.sh 0
