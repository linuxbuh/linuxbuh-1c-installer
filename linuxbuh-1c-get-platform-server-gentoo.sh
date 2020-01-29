#!/bin/bash

#Колличество знаков # означают начало и конец определенной процедуры с наименованием, чем больше знаков - тем длиннее процедура
MACHINE_TYPE=`uname -m`
if [ $MACHINE_TYPE == x86_64 ]; then
    OSBITVER=64
fi
if [ $MACHINE_TYPE == 32 ]; then
    OSBITVER=32
fi

if [ $OSBITVER == 32 ]; then
    OSBIT=32
    BITPACKETVER=i386
fi
if [ $OSBITVER == 64 ]; then
    OSBIT=64
    BITPACKETVER=amd64
fi

PAKET=deb
PAKETNAME=$PAKET$OSBIT

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
#echo "Подождите.Начинаем работать. Подключаемся к серверу 1С"

VER=$3

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

#    grep 'a href="/version_files?nick=Platform83' |
#    tr -s '="  ' ' ' |
#    awk -F ' ' '{print $5}' |
#    sort -Vr | pr -T -5

#read -i "8.3." -p "Выбирите версию для загрузки (введите два последних номера версии через точку - например 14.1565: " -e VER

if [[ -z "$VER" ]];then
    echo "VERSION не выбрана"
    exit 1
fi

if [[ "8.3." = "$VER" ]];then
    echo "Введен не полный номер версии VERSION"
    exit 1
fi

#Устанавливаем архитектуру ядра Linux
MACHINE_TYPE=`uname -m`

VERPLATFORM=$VER
#Заменяем точки на нижнее подчеркивание в версии платформы
VERPLATFORM1=${VER//./_}
#

#Точки в версии платформы
VERPLATFORM2=${VER//./}
#

#Проверка на версию платформы 1С, все что равно и выше версии 8.3.12.1469. В версии 8.3.12.1469 на сайте 1С поменяли наименование пакетов для скачивания.
#Было наименование например client.deb64.tar.gz стало client_8_3_12_1469_deb64.tar.gz

#Функция для сравнения версий
function version_platform { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

    #Сравнение версий, если версия ниже 8.3.12.1469 то качаем после else
    if [ $(version_platform $VERPLATFORM) -ge $(version_platform "8.3.12.1469") ]; then

	#если x86_64
	if [ ${OSBIT} == '64' ]; then

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\${PAKETNAME}_${VERPLATFORM1}.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        else

	#если x86
		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\${PAKET}_${VERPLATFORM1}.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')
        fi
    #Сравнение версий, если версия ниже 8.3.12.1469 качем отсюда
    else

        if [ ${OSBIT} == '64' ]; then

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        else

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\$PAKET.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        fi

    fi




mkdir -p /tmp/platform1c

if [ ${MACHINE_TYPE} == 'x86_64' ]; then

    echo "Закачиваем серверную часть версии для архитектуры $MACHINE_TYPE"
    curl --fail -b /tmp/cookies.txt -o /tmp/platform1c/${VER}.server64.tar.gz -L "$SERVERLINK"

else

    echo "Закачиваем серверную часть версии для архитектуры $MACHINE_TYPE"
    curl --fail -b /tmp/cookies.txt -o tmp/platform1c/${VER}.server32.tar.gz -L "$SERVERLINK"

fi

#удаляем файл с куки
rm /tmp/cookies.txt

echo "Распаковываем платформу 1C"

mkdir /tmp/platform1c

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    tar -xvf /tmp/platform1c/${VER}.server64.tar.gz -C /tmp/platform1c
else
    tar -xvf /tmp/platform1c/${VER}.server32.tar.gz -C /tmp/platform1c
fi

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    rm /tmp/platform1c/${VER}.server64.tar.gz
else
    rm /tmp/platform1c/${VER}.server32.tar.gz
fi

echo "Преобразовываем deb пакеты в tar.gz"
deb2targz /tmp/platform1c/*.deb

echo "Удаляем deb пакеты"
rm /tmp/platform1c/*.deb

echo "Перемещаем tar.gz в папку /var/calculate/remote/distfiles"
mv /tmp/platform1c/*.tar.gz /var/calculate/remote/distfiles

mv /tmp/platform1c/license-tools /tmp/platform1c/license-tools-$VER
cd /tmp/platform1c
tar -cvzf /var/calculate/remote/distfiles/license-tools-${VER}.tar.gz ./license-tools-$VER

#удаляем папку
rm -Rf /tmp/platform1c

echo "Теперь выполните комманду по установке 1С клиента, например emerge 1c-enterprise83-client-$VER"

