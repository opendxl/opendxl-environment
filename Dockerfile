FROM python:2.7-slim

VOLUME ["/opendxl"]

RUN apt-get update \
    && apt-get install -y curl git unzip wget telnet vim python3 \
    && curl -sL https://deb.nodesource.com/setup_8.x | /bin/bash - \
    && apt-get install -y nodejs build-essential \
    && npm i cloudcmd -g \
    && npm i gritty \
    && apt-get remove -y --auto-remove build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install sphinx dxlclient==4.0.0.418 dxlbootstrap==0.1.4 twine
    
RUN wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' && \
	python3 get-pip.py --disable-pip-version-check --no-cache-dir && \
    rm -f get-pip.py && \
    cp -f /usr/local/bin/pip2 /usr/local/bin/pip

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
