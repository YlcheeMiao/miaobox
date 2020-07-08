# Before building this, please first build:
# - cudagl:10.1
# - pytorch:1.4-cudagl10.1
# WARNING: stage name must be all lowercase
# global ARGs must be declared before the first FROM
# https://github.com/moby/moby/issues/38379
ARG GUI_BASE=cli-full

# ================= Stage 1: Basics =================
ARG BASE_IMAGE=linxifan/pytorch:1.5-cudagl10.1
FROM $BASE_IMAGE as basic

ENV BUILD_DIR=/opt/docker-build

# must install locales to avoid weird locale issues
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    unzip p7zip p7zip-rar \
    locales locales-all \
    aria2 man iputils-ping && \
    rm -rf /var/lib/apt/lists/*

#RUN pip install -U wandb pyzmq ray

RUN mkdir -p $BUILD_DIR && chmod -R 777 $BUILD_DIR

# ========== Fix UID ===========
ENV USER=user
ENV GROUP=docker

# first line adds /opt/conda/bin to sudo path,
# so that we can use `sudo conda install` as user
# second line enables all users in sudo group to sudo without password
RUN sed -i -e 's/:\/bin:/:\/bin:\/opt\/conda\/bin:/1' /etc/sudoers &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# 1001 is an arbitrary number
RUN addgroup --gid 1001 $GROUP && \
    adduser --uid 1001 --ingroup $GROUP --shell /usr/bin/zsh --gecos "" --home /home/$USER $USER
RUN usermod -aG sudo $USER

# https://github.com/boxboat/fixuid
# /etc/fixuid/config.yml (`paths` key is for recursively chown):
  #user: user
  #group: docker
  #paths:
  #  - /home/user
RUN curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\npaths:\n  - /home/$USER" > /etc/fixuid/config.yml
#    printf "user: $USER\ngroup: $GROUP\npaths:\n  - /home/$USER\n  - /opt/conda" > /etc/fixuid/config.yml

# for entrypoint script
ENV SANDCASTLE_BUILD_MODE=cli

COPY ./entrypoint.sh /opt/entrypoint-base.sh
RUN chmod +x /opt/entrypoint-base.sh && ln -fs /opt/entrypoint-base.sh /opt/entrypoint.sh

USER $USER:$GROUP
ENV HOME=/home/$USER
ENV PATH=/home/$USER/.local/bin:$PATH
WORKDIR $HOME

ENTRYPOINT ["/opt/entrypoint.sh"]

# ========================= Stage 2(A) CLI lightweight =========================
FROM basic AS cli-lite
# flag to notify installation scripts that they are inside a docker build
ENV MY_DOCKER_BUILD=1
# for entrypoint script
ENV SANDCASTLE_BUILD_MODE=cli

USER root:root
WORKDIR $BUILD_DIR

# our own binaries will be installed here
ENV BIN_DIR=$HOME/.bin
RUN mkdir -p $BIN_DIR

# install zsh
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    zsh openssh-server rsync && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U trash-cli

COPY misc ./misc
COPY misc/sshd_config /etc/ssh/sshd_config
RUN chmod +x misc/install-exa.sh && misc/install-exa.sh
RUN chmod +x misc/install-misc.sh && misc/install-misc.sh

COPY zsh/_zshrc_lite $HOME/.zshrc

USER $USER:$GROUP
ENTRYPOINT ["/opt/entrypoint.sh"]

# ========================= Stage 2(B): CLI full =========================
FROM cli-lite AS cli-full

USER root:root
# for VPN: iproute2 is better than net-tools, but we retain both for compatibility
# https://www.thegeekdiary.com/comparing-net-tools-v-s-iproute-package-commands/
RUN apt update -q && DEBIAN_FRONTEND=noninteractive apt install -y \
    openconnect sshfs net-tools iproute2 && \
    rm -rf /var/lib/apt/lists/*

USER $USER:$GROUP

ENV SANDCASTLE_BUILD_MODE=cli
ENV CONFIG_ROOT=$HOME/configs

# python-language-server is for TabNine
RUN sudo pip install -U \
    python-language-server

WORKDIR $BUILD_DIR

COPY tmux ./tmux
RUN sudo chmod +x tmux/install.sh && tmux/install.sh

COPY zsh/install-zsh.sh ./
COPY zsh/apply-antigen.sh $HOME/.apply-antigen.sh
RUN sudo chmod +x install-zsh.sh && ./install-zsh.sh

COPY vim/install-vim.sh ./
# temporary for VimPlug installation: .vimrc will be overwritten by symlink
COPY vim/_vimrc $HOME/.vimrc
RUN sudo chmod +x install-vim.sh && ./install-vim.sh

# additional zshrc settings specific only to this docker machine
RUN echo '[ -f $HOME/.zsh/extra_docker.sh ] && source $HOME/.zsh/extra_docker.sh' >> $HOME/.extra.sh

# clean up apt cache
RUN sudo rm -rf /var/lib/apt/lists/*

WORKDIR $HOME
ENTRYPOINT ["/opt/entrypoint.sh"]

# ====================== Stage 3: Add GUI and VNC ====================
# GUI can be based on either cli-lite or cli-full
FROM $GUI_BASE AS gui
# for entrypoint script
ENV SANDCASTLE_BUILD_MODE=gui

USER root:root
WORKDIR $BUILD_DIR

# WARNING: do NOT add --no-install-recommends, otherwise Xorg won't be installed
RUN apt update -q && DEBIAN_FRONTEND=noninteractive apt install -y \
    xfce4 xfce4-terminal desktop-base && \
    rm -rf /var/lib/apt/lists/*

# firefox crashes with Nvidia GPU driver on Ubuntu 18.04, so we have to use Chrome
# if you want firefox, just run `apt install -y firefox`
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt update -q && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm -rf google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# disable screensaver
RUN apt autoremove -y xscreensaver
# set xfce4 terminal as default
RUN echo 2 | update-alternatives --config x-terminal-emulator

# install teamviewer
#RUN wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -O ./teamviewer_amd64.deb
#RUN dpkg -i ./teamviewer_amd64.deb; exit 0
#RUN apt install -f -y

RUN wget https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.10.1.x86_64.tar.gz -O ./tigervnc.tar.gz
RUN tar xf tigervnc.tar.gz && cp -rf tigervnc-1.10.1.x86_64/usr/* /usr/ && rm -f tigervnc.tar.gz

USER $USER:$GROUP
# install nerdfonts
RUN mkdir -p $HOME/.local/share/fonts
COPY fonts/* $HOME/.local/share/fonts
RUN mkdir -p $HOME/.config/xfce4/terminal
COPY misc/xfce4-terminal.conf $HOME/.config/xfce4/terminal/terminalrc

ENV QT_X11_NO_MITSHM=1
ENV DISPLAY=:0

WORKDIR $HOME
# You must use the exec form of ENTRYPOINT to be able to receive docker run command args
ENTRYPOINT ["/opt/entrypoint.sh"]
