FROM python:2.7-slim

VOLUME ["/opendxl"]

COPY opendxl-cloudcmd/package.json /opendxl-cloudcmd/

RUN apt-get update \
    && apt-get install -y curl git unzip wget telnet \
    && curl -sL https://deb.nodesource.com/setup_8.x | /bin/bash - \
    && apt-get install -y nodejs build-essential \
    && cd /opendxl-cloudcmd \
    && npm i \
    && cd / \
    && apt-get remove -y --auto-remove build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install sphinx dxlclient==4.0.0.417 dxlbootstrap==0.1.4

COPY opendxl-cloudcmd/opendxl-cloudcmd.js /opendxl-cloudcmd/

COPY files/.bashrc /root
COPY files/edit.json /opendxl-cloudcmd/node_modules/edward/json/
COPY dxlenvironment /dxlenvironment

EXPOSE 9443

ENTRYPOINT ["/dxlenvironment/startup.sh"]
