#!/usr/bin/bash

microsocks &

echo -e "${VPN_PASSWORD}\n${VPN_AUTH_CHAIN}\n${VPN_OTP}" |
openconnect --protocol=nc --user="${VPN_USER_ID}" --passwd-on-stdin "${VPN_SERVER}"

# See https://docs.docker.com/config/containers/multi-service_container

# Wait for any process to exit
# wait -n

# Exit with status of process that exited first
# exit $?
