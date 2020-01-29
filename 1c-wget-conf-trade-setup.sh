#!/bin/bash

#Берем имя пользователя и пароль из строки
USERNAME=$1
PASSWORD=$2

#Проверяем имя пользователя и пароль
if [[ -z "$USERNAME" ]];then
    echo "Имя пользователя не указано"
    exit 1
fi

if [[ -z "$PASSWORD" ]];then
    echo "Пароль не указан"
    exit 1
fi

echo "Подождите.Начинаем работать. Подключаемся к серверу 1С"

#Подключаемся к серверу 1С
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
    echo "Ошибка аутентификации"
    exit 1
fi

clear

curl -s -b /tmp/cookies.txt https://releases.1c.ru/project/Trade110 |

    grep 'a href="/version_files?nick=Trade110' |
    tr -s '="  ' ' ' |
    awk -F ' ' '{print $5}' |
    sort -Vr | pr -T -6

read -i "11." -p "Input version for download: " -e VER

if [[ -z "$VER" ]];then
    echo "VERSION not set"
    exit 1
fi

if [[ "11." = "$VER" ]];then
    echo "Need full VERSION number"
    exit 1
fi

#Убираем точки из версии
VER0=${VER//./}
#Заменяем точки на нижнее подчеркивание в версии
VER1=${VER//./_}
#Подмена версии
VER4=${VER//./_}_setup1c

#if [ $VER0 -ge 1134228 -a $VER0 -ge 114524 ]; then

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

if [ $(version $VER) -ge $(version "11.3.4.228") ]; then

CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Trade110" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Trade\\$VER1\\Trade_$VER4.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

else

CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Trade110" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Trade\\$VER1\\setup1c.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

fi

mkdir -p /tmp/conf1ctradesetup

curl --fail -b /tmp/cookies.txt -o /tmp/conf1ctradesetup/Trade_$VER4.exe -L "$CLIENTLINK"

rm /tmp/cookies.txt

#Распаковываем
cd /tmp/conf1ctradesetup
unrar e /tmp/conf1ctradesetup/Trade_$VER4.exe

sh setup

rm -R /tmp/conf1ctradesetup