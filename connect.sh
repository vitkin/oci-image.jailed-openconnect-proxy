#!/usr/bin/env bash

VPN_ENV_FILE="${VPN_ENV_FILE:-$( dirname "${BASH_SOURCE[0]}" )/env.sh}"

# shellcheck source=env.sh
[ -f "${VPN_ENV_FILE}" ] && source "${VPN_ENV_FILE}"

# TODO: Check for update that would make the workaround unnecessary.
# Workaround for credential_process not connecting subprocess stderr to
# caller stderr because of boto/botocore.
# This is a very old bug that exists only for AWS Python SDK.
# See https://github.com/aws/aws-sdk/issues/358
VPN_INTERACTIVE_OUTPUT="${VPN_INTERACTIVE_OUTPUT:-/dev/tty}"

_RED=$'\e[0;31m'
_BLUE=$'\e[0;34m'
_NORMAL=$'\e[m'

# shellcheck disable=SC2317
cli_read() {
  {
    # shellcheck disable=SC2086
    read -${2}rp "${_RED}${1}: ${_NORMAL}"
    if [ -n "${2}" ]; then echo; fi
  } 2>> "${VPN_INTERACTIVE_OUTPUT}" >&2

  echo "${REPLY}"
}

# shellcheck disable=SC2317
cli_select() {
  PS3="${_RED}${1}: ${_NORMAL}"

  {
    eval "
      select opt in \"\${${2}[@]}\"; do
        REPLY=\"\${opt:-\${1}}\"
        break
      done

      echo \"\${_BLUE}${3}\${_NORMAL}\"
    "
  } 2>> "${VPN_INTERACTIVE_OUTPUT}" >&2

  echo "${REPLY}"
}


VPN_USER_ID_PROCESS="${VPN_USER_ID_PROCESS:-\
cli_read 'Enter your user ID'}"

VPN_USER_ID="${VPN_USER_ID:-$( eval "${VPN_USER_ID_PROCESS}" )}"
export VPN_USER_ID


VPN_PASSWORD_PROCESS="${VPN_PASSWORD_PROCESS:-\
cli_read 'Enter your password' 's'}"

VPN_PASSWORD="$( eval "${VPN_PASSWORD_PROCESS}" )"
export VPN_PASSWORD


# shellcheck disable=SC2034
form_select_options=(
  'Smartphone Push'
  'SMS OTP'
  'Phone OTP'
  'Physical Token'
)

# shellcheck disable=SC2016
VPN_AUTH_CHAIN_PROCESS="${VPN_AUTH_CHAIN_PROCESS:-\
cli_select 'Select an authentication chain' 'form_select_options' '\${REPLY}'}"

VPN_AUTH_CHAIN="${VPN_AUTH_CHAIN:-$( eval "${VPN_AUTH_CHAIN_PROCESS}" )}"
export VPN_AUTH_CHAIN


# shellcheck disable=SC2016
VPN_OTP_PROCESS="${VPN_OTP_PROCESS:-\
cli_read 'Enter your OTP'}"

VPN_OTP="$( eval "${VPN_OTP_PROCESS}" )"
export VPN_OTP


docker container run \
  -d \
  --rm \
  --init \
  --name jailed-openconnect-proxy \
  -p "${VPN_PROXY_PORT:-1080}:1080" \
  --cap-add NET_ADMIN \
  -e VPN_SERVER \
  -e VPN_USER_ID \
  -e VPN_PASSWORD \
  -e VPN_AUTH_CHAIN \
  -e VPN_OTP \
  jailed-openconnect-proxy

# vim: set filetype=bash tabstop=2 foldmethod=marker expandtab:
