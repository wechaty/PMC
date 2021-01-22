#!/usr/bin/env bash
#
# Copyright 2020 Huan (李卓桓) <zixia@zixia.net>
# Wechaty Contributors
#
set -eo pipefail

if [ -z "$GITHUB_TOKEN" ]; then
  >&2 echo "GITHUB_TOKEN not set."
fi

function orgId () {
  org=$1
  curl -sH "Authorization: token $GITHUB_TOKEN"   \
    "https://api.github.com/orgs/$1" |\
    jq '.id'
}

function teamId () {
  org=$1
  team=$2
  curl -sH "Authorization: token $GITHUB_TOKEN"   \
    "https://api.github.com/orgs/$org/teams"   |\
    jq 'map(select(.name | match("'$team'";"i"))) | .[].id'
}

function members () {
  org=$1
  team=$2

  page=1
  while true; do
    json=$(curl --fail -sH "Authorization: token $GITHUB_TOKEN" \
                "https://api.github.com/organizations/$(orgId $org)/team/$(teamId $org $team)/members?per_page=100&page=${page}")
    [ "$?" -ne 0 ] && break

    length=$(echo "$json" | jq length)
    [ "$length" -eq 0 ] && break

    echo "$json"
    page=$((page+1))
  done
}

function memberId () {
  org=$1
  team=$2
  login=$3
  members "$org" "$team" |\
    jq 'map(select(.login | match("^'$login'$";"i"))) | .[].id'
}

function memberLoginList () {
  org=$1
  team=$2
  members "$org" "$team" |\
    jq -r 'map(select(.login)) | .[].login'
}

function keys () {
  login=$1
  curl -sH "Authorization: token $GITHUB_TOKEN"   \
    https://api.github.com/users/$login/keys |\
    jq -r 'map(select(.key)) | .[].key'
}

for login in $(memberLoginList wechaty contributors); do
  SSH_DIR="/home/$login/.ssh"
  KEY_FILE="$SSH_DIR/authorized_keys"
  KEY_PUB=$(keys $login)

  cat<<_POD_

  if [ ! -d "/home/$login" ]; then
    useradd -m $login
  fi
  if [ ! -d "$SSH_DIR" ]; then
    mkdir "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    chown "$login"."$login" "$SSH_DIR"
  fi
  cat<<_EOF_ > "$KEY_FILE"
$KEY_PUB
_EOF_
  chmod 0600 "$KEY_FILE"
  chown "$login"."$login" "$KEY_FILE"
_POD_

done

