FROM python:2.7-slim

ARG DXL_CLIENT_VERSION=4.1.0.187
ARG DXL_BOOTSTRAP_VERSION=0.2.0
ARG CLOUDCMD_VERSION=^10.0.0
ARG NODE_SETUP=setup_6.x

VOLUME ["/opendxl"]

RUN apt-get update \
    && apt-get install -y curl git unzip wget telnet vim python3 gnupg iproute2 \
    && curl -sL https://deb.nodesource.com/${NODE_SETUP} | /bin/bash - \
    && apt-get install -y nodejs build-essential \
    && npm i cloudcmd@${CLOUDCMD_VERSION} -g \
    && npm i gritty \
    && apt-get remove -y --auto-remove build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' && \
	python3 get-pip.py --disable-pip-version-check --no-cache-dir && \
    rm -f get-pip.py && \
    cp -f /usr/local/bin/pip2 /usr/local/bin/pip
    
RUN pip3 install sphinx dxlclient==${DXL_CLIENT_VERSION} dxlbootstrap==${DXL_BOOTSTRAP_VERSION} twine && \
    pip install sphinx dxlclient==${DXL_CLIENT_VERSION} dxlbootstrap==${DXL_BOOTSTRAP_VERSION} twine

COPY files/.bashrc /root
COPY files/vimrc.local /etc/vim
COPY files/edit.json /usr/lib/node_modules/cloudcmd/node_modules/edward/json/
COPY dxlenvironment /dxlenvironment

ENV cloudcmd_contact false
ENV cloudcmd_console false
ENV cloudcmd_one_panel_mode true
ENV cloudcmd_terminal true
ENV cloudcmd_terminal_path gritty

EXPOSE 8000

ENTRYPOINT ["/dxlenvironment/startup.sh"]
