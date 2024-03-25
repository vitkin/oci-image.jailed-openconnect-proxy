# Jailed Openconnect Proxy

Run an Openconnect VPN client in a container and access the network behind
the VPN through a SOCKS5 proxy.

## Build

Create the Docker image by running the `./build.sh` script.

## Usage

Use the helper scripts `./connect.sh` and `./disconnect.sh` to connect and
disconnect the VPN.

## Configuration

Create a configuration file `env.sh` with a content similar to the following:

```sh
#!/usr/bin/env bash

# export VPN_PROXY_PORT=1080

# Split tunnel
# export VPN_SERVER='<fqdn>'

# Split tunnel disabled
export VPN_SERVER='<fqdn>/fullvpn'

export VPN_USER_ID='<user id>'

export VPN_AUTH_CHAIN='Phone OTP'

# VPN_PASSWORD_PROCESS="kwallet-query -f 'Jailed Openconnect Proxy' -r '${VPN_USER_ID}' kdewallet"

# VPN_OTP_PROCESS="kwallet-query -f 'Jailed Openconnect Proxy' -r '${VPN_USER_ID}/otp-secret-key' kdewallet | oathtool -b --totp -"
```
