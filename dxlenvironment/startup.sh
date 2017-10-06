#!/bin/bash

DOCKER_HOSTNAME=dockerhost
DOCKER_HOSTIP=$(ip route | sed -n 's/.*default via \([^ ]*\).*/\1/p')

# Add entry for docker host to the /etc/hosts file
if [ -n $DOCKER_HOSTIP ]; then
    echo "Using docker host IP address ${DOCKER_HOSTIP}"
    if ! grep -q $DOCKER_HOSTNAME /etc/hosts 2>/dev/null; then
        echo -e "\n${DOCKER_HOSTIP} ${DOCKER_HOSTNAME}" >> /etc/hosts
        if [ $? -ne 0 ]; then
            echo "Failed to add docker host entry to /etc/hosts file" >&2
        fi
    fi
else
    echo "Unable to determine docker host IP address" >&2
fi

# Run cloud commander
cloudcmd
