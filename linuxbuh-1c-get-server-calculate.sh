#!/bin/bash

#Колличество знаков # означают начало и конец определенной процедуры с наименованием, чем больше знаков - тем длиннее процедура

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
#
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

#Выводим список версий платформы
curl -s -b /tmp/cookies.txt https://releases.1c.ru/project/Platform83 |

    grep 'a href="/version_files?nick=Platform83' |
    tr -s '="  ' ' ' |
    awk -F ' ' '{print $5}' |
    sort -Vr | pr -T -5

read -i "8.3." -p "Выбирите версию для загрузки (введите два последних номера версии через точку - например 14.1565: " -e VER

if [[ -z "$VER" ]];then
    echo "VERSION не выбрана"
    exit 1
fi

if [[ "8.3." = "$VER" ]];then
    echo "Введен не полный номер версии VERSION"
    exit 1
fi

#Заменяем точки на нижнее подчеркивание в версии платформы
VER1=${VER//./_}

#Точки в версии платформы
VER2=${VER//./}

#Устанавливаем архитектуру ядра Linux
MACHINE_TYPE=`uname -m`

#Проверка на версию платформы 1С, все что равно и выше версии 8.3.12.1469. В версии 8.3.12.1469 на сайте 1С поменяли наименование пакетов для скачивания.
#Было наименование например client.deb64.tar.gz стало client_8_3_12_1469_deb64.tar.gz
if [ $VER2 -ge 83121469 ]; then

#если x86_64
if [ ${MACHINE_TYPE} == 'x86_64' ]; then

SERVERLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Platform\\$VER1\\deb64_$VER1.tar.gz" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

else

#если x86
SERVERLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Platform\\$VER1\\deb_$VER1.tar.gz" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

fi

else

if [ ${MACHINE_TYPE} == 'x86_64' ]; then

SERVERLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Platform\\$VER1\\deb64.tar.gz" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

else

SERVERLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=Platform\\$VER1\\deb.tar.gz" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

fi

fi

mkdir -p /tmp/dist1c

if [ ${MACHINE_TYPE} == 'x86_64' ]; then

    echo "Закачиваем серверную часть версии для архитектуры $MACHINE_TYPE"
    curl --fail -b /tmp/cookies.txt -o /tmp/dist1c/${VER}.server64.tar.gz -L "$SERVERLINK"

else

    echo "Закачиваем серверную часть версии для архитектуры $MACHINE_TYPE"
    curl --fail -b /tmp/cookies.txt -o tmp/dist1c/${VER}.server32.tar.gz -L "$SERVERLINK"

fi

#удаляем файл с куки
rm /tmp/cookies.txt

echo "Распаковываем платформу 1C"

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    tar -xvf /tmp/dist1c/${VER}.client64.tar.gz -C /tmp/dist1c
    tar -xvf /tmp/dist1c/${VER}.server64.tar.gz -C /tmp/dist1c
else
    tar -xvf /tmp/dist1c/${VER}.client32.tar.gz -C /tmp/dist1c
    tar -xvf /tmp/dist1c/${VER}.server32.tar.gz -C /tmp/dist1c
fi

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    rm /tmp/dist1c/${VER}.client64.tar.gz
    rm /tmp/dist1c/${VER}.server64.tar.gz
else
    rm /tmp/dist1c/${VER}.client32.tar.gz
    rm /tmp/dist1c/${VER}.server32.tar.gz
fi

echo "Преобразовываем deb пакеты в tar.gz"
deb2targz /tmp/dist1c/*.deb

echo "Удаляем deb пакеты"
rm /tmp/dist1c/*.deb

echo "Перемещаем tar.gz в папку /var/calculate/remote/distfiles"
mv /tmp/dist1c/*.tar.gz /var/calculate/remote/distfiles

#удаляем папку
#rm -R /tmp/dist1c

echo "Теперь выполните комманду по установке 1С клиента, например emerge 1c-enterprise83-client-$VER"
