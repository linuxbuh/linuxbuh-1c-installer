#!/bin/bash

#20180809

USERNAME=9257976
PASSWORD=ztd57s4s

if [[ -z "$USERNAME" ]];then
    echo "USERNAME not set"
    exit 1
fi

if [[ -z "$PASSWORD" ]];then
    echo "PASSWORD not set"
    exit 1
fi

echo "Getting versions, please wait."

SRC=$(curl -c /tmp/cookies.txt -s -L https://releases.1c.ru)

ACTION=$(echo "$SRC" | grep -oP '(?<=form method="post" id="loginForm" action=")[^"]+(?=")')
EXECUTION=$(echo "$SRC" | grep -oP '(?<=input type="hidden" name="execution" value=")[^"]+(?=")')

curl -s -L \
    -o /dev/null \
    -b /tmp/cookies.txt \
    -c /tmp/cookies.txt \
    --data-urlencode "inviteCode=" \
    --data-urlencode "execution=$EXECUTION" \
    --data-urlencode "_eventId=submit" \
    --data-urlencode "username=$USERNAME" \
    --data-urlencode "password=$PASSWORD" \
    https://login.1c.ru"$ACTION"


if ! grep -q "TGC" /tmp/cookies.txt ;then
    echo "Auth failed"
    exit 1
fi

clear

curl -s -b /tmp/cookies.txt https://releases.1c.ru/project/Trade110 |

    grep 'a href="/version_files?nick=Trade110' |
    tr -s '="  ' ' ' |
    awk -F ' ' '{print $5}' |
    sort -Vr | pr -T -5

read -i "11." -p "Input version for download: " -e VER

if [[ -z "$VER" ]];then
    echo "VERSION not set"
    exit 1
fi

if [[ "11." = "$VER" ]];then
    echo "Need full VERSION number"
    exit 1
fi

VER1=${VER//./_}
VER2=${VER//./_}_updsetup
VER3=${VER//./_}_updstpb
VER4=${VER//./_}_setup1c

CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Trade110" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Trade\\$VER1\\Trade_$VER2.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Trade110" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Trade\\$VER1\\Trade_$VER3.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Trade110" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Trade\\$VER1\\Trade_$VER4.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')


mkdir -p dist

curl --fail -b /tmp/cookies.txt -o dist/Trade_$VER2.exe -L "$CLIENTLINK"
curl --fail -b /tmp/cookies.txt -o dist/Trade_$VER3.exe -L "$CLIENTLINK"
curl --fail -b /tmp/cookies.txt -o dist/Trade_$VER4.exe -L "$CLIENTLINK"

rm /tmp/cookies.txt
