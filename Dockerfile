FROM python:2.7-slim

ARG DXL_CLIENT_VERSION=5.6.0.1
ARG DXL_BOOTSTRAP_VERSION=0.2.2
ARG CLOUDCMD_VERSION=^9.0.0
ARG GRITTY_VERSION=^3.0.0
ARG NODE_SETUP=setup_6.x

VOLUME ["/opendxl"]

RUN apt-get update \
    && apt-get install -y curl git unzip wget telnet vim python3 gnupg iproute2 \
    && curl -sL https://deb.nodesource.com/${NODE_SETUP} | /bin/bash - \
    && mkdir -p /usr/share/man/man1 \
    && apt-get install -y nodejs build-essential openjdk-8-jdk-headless \
    && npm i cloudcmd@${CLOUDCMD_VERSION} -g \
    && npm i gritty@${GRITTY_VERSION} \
    && npm install -g bootprint \
    && npm install -g bootprint-opendxl \
    && apt-get remove -y --auto-remove build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/dxlschema/v0.1 \
    && cd /root/dxlschema/v0.1 \
    && wget https://opendxl.github.io/opendxl-api-specification/v0.1/schema.json
    
RUN wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' && \
	python3 get-pip.py --disable-pip-version-check --no-cache-dir && \
    rm -f get-pip.py && \
    cp -f /usr/local/bin/pip2 /usr/local/bin/pip
    
RUN pip3 install sphinx dxlclient==${DXL_CLIENT_VERSION} dxlbootstrap==${DXL_BOOTSTRAP_VERSION} twine jsonschema && \
    pip install sphinx dxlclient==${DXL_CLIENT_VERSION} dxlbootstrap==${DXL_BOOTSTRAP_VERSION} twine jsonschema

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
