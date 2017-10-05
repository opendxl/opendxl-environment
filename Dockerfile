FROM python:2.7-slim

VOLUME ["/opendxl"]

RUN apt-get update \
    && apt-get install -y curl git unzip wget telnet \
    && curl -sL https://deb.nodesource.com/setup_8.x | /bin/bash - \
    && apt-get install -y nodejs build-essential \
    && npm i cloudcmd -g \
    && npm i gritty \
    && apt-get remove -y --auto-remove build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install dxlclient dxlbootstrap sphinx

COPY files/.bashrc /root
COPY files/edit.json /usr/lib/node_modules/cloudcmd/node_modules/edward/json/

ENV cloudcmd_contact false
ENV cloudcmd_console false
ENV cloudcmd_one_panel_mode true
ENV cloudcmd_terminal true
ENV cloudcmd_terminal_path gritty

EXPOSE 8000

ENTRYPOINT ["cloudcmd"]
