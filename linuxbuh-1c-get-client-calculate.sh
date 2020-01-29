#!/bin/bash

#Колличество знаков # означают начало и конец определенной процедуры с наименованием, чем больше знаков - тем длиннее процедура

#Берем имя пользователя и пароль из строки
USERNAME=$1
PASSWORD=$2
#

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

#Устанавливаем архитектуру ядра Linux
MACHINE_TYPE=`uname -m`
if [ $MACHINE_TYPE == x86_64 ]; then
    OSBIT=64
fi
if [ $MACHINE_TYPE == 32 ]; then
    OSBIT=32
fi
#

#Определяем дистрибутив
#source /etc/os-release
source /tmp/os-release
OSRELEASE=$ID

echo -e "\e[1;33;4;44mВаш дистрибутив LINUX - $OSRELEASE $OSBIT\e[0m"
#

#Самостоятельно установить вид пакета или дать выбор пакетного менеджера
echo
echo -e "\e[1;31;42mСамостоятельно определить вид пакетов по типу пкетного менеджера?\e[0m"
echo
PS3='Самостоятельно определить вид пакетов по типу пакетного менеджера? '
echo
select AUTOPAKETMANAGER in "Да" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $AUTOPAKETMANGER\e[0m"
  echo
  break
done
    if [[ -z "$AUTOPAKETMANAGER" ]];then
    echo  -e "\e[31mНичего не указана\e[0m"
    exit 1
    fi

    if [ $AUTOPAKETMANAGER = "Да" ]; then
	#Устанавливаем какие пакеты качать deb или rpm
	if [ $OSRELEASE = calculate ]; then
	    PAKET=deb
	    PAKETEMERGE=EMERGE
	    PAKETNAME=$PAKET$OSBIT
	    PAKETMANAGER=EMERGE
	fi
	if [ $OSRELEASE = gentoo ]; then
	    PAKET=deb
	    PAKETEMERGE=EMERGE
	    PAKETNAME=$PAKET$OSBIT
	    PAKETMANAGER=EMERGE
	fi
	if [ $OSRELEASE = ubuntu ]; then
	    PAKET=deb
	    PAKETNAME=$PAKET$OSBIT
	    PAKETMANAGER=DEB
	fi
	if [ $OSRELEASE = debian ]; then
	    PAKET=deb
	    PAKETNAME=$PAKET$OSBIT
	    PAKETMANAGER=DEB
	fi
	if [ $OSRELEASE = fedora ]; then
	    PAKET=rpm
	    PAKETNAME=$PAKET$OSBIT
	    PAKETMANAGER=RPM
	fi
    fi

    if [ $AUTOPAKETMANAGER = "Нет" ]; then
    #пакетный менеджер
    echo
    echo -e "\e[1;31;42mВыбор вида пакетов\e[0m"
    echo
    PS3='Какие пакеты понимает Ваш пакетный менеджер ( для Calculate-Linux и Gentoo выбирайте EMERGE )'
    echo
    select PAKETVIBOR in "DEB" "RPM" "EMERGE"
    do
      echo
      echo -e "\e[1;34;4mВы выбрали $PAKETVIBOR\e[0m"
      echo
      break
    done
    if [[ -z "$PAKETVIBOR" ]];then
        echo  -e "\e[31mВид пакета не указан\e[0m"
        exit 1
    fi
    if [ $PAKETVIBOR = "DEB" ]; then
	    PAKET=deb
	    PAKETNAME=$PAKET$OSBIT
	    PAKETMANAGER=DEB
    fi
    if [ $PAKETVIBOR = "RPM" ]; then
	    PAKET=rpm
	    PAKETNAME=$PAKET$OSBIT
	    PAKETMANAGER=RPM
    fi
    if [ $PAKETVIBOR = "EMERGE" ]; then
	    PAKET=deb
	    PAKETNAME=$PAKET$OSBIT
	    PAKETMANAGER=DEB
    fi

#
fi
#


echo "$PAKETNAME"

#Меню - сервер или клиент
echo -e "\e[1;31;42mЧто устанавливаем\e[0m"
echo
PS3='Устанавливаем клиент или сервер (нажмите цифру 1 - Клиент, 2 - Сервер) : '
echo
select SERVER_CLIENT in "Клиент" "Сервер"
do
  break
done
#
if [ $SERVER_CLIENT = "Клиент" ]; then
    echo
    echo -e "\e[1;31mВы выбрали $SERVER_CLIENT.\e[0m"
    echo
fi
if [ $SERVER_CLIENT = "Сервер" ]; then
    echo
    echo -e "\e[1;31mВы выбрали $SERVER_CLIENT.\e[0m"
    echo
fi
#

#Начинаем работу
echo
echo -e "\e[1;33;4;44mПодождите. Начинаем работать. Подключаемся к серверу 1С\e[0m"
echo
#

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
#

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
#

#Заменяем точки на нижнее подчеркивание в версии платформы
VER1=${VER//./_}
#

#Точки в версии платформы
VER2=${VER//./}
#

#Проверка на версию платформы 1С, все что равно и выше версии 8.3.12.1469. В версии 8.3.12.1469 на сайте 1С поменяли наименование пакетов для скачивания.
#Было наименование например client.deb64.tar.gz стало client_8_3_12_1469_deb64.tar.gz

#Функция для сравнения версий
function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

#Если качаем клиент
if [ $SERVER_CLIENT = "Клиент" ]; then

    #Сравнение версий, если версия ниже 8.3.12.1469 то качаем после else
    if [ $(version $VER) -ge $(version "8.3.12.1469") ]; then

	#если x86_64
	if [ ${MACHINE_TYPE} == 'x86_64' ]; then

		CLIENTLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\client_$VER1.$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\${PAKETNAME}_${VER1}.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        else

	#если x86
		CLIENTLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\client_$VER1.$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\{PAKET}_${VER1}.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')
        fi
    #Сравнение версий, если версия ниже 8.3.12.1469 качем отсюда
    else

        if [ ${MACHINE_TYPE} == 'x86_64' ]; then

		CLIENTLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
	    --data-urlencode "nick=Platform83" \
	    --data-urlencode "ver=$VER" \
	    --data-urlencode "path=Platform\\$VER1\\client.$PAKETNAME.tar.gz" \
	    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        else

		CLIENTLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\client.$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\$PAKET.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        fi

    fi

fi

if [ $SERVER_CLIENT = "Сервер" ]; then

    #Сравнение версий, если версия ниже 8.3.12.1469 то качаем после else
    if [ $(version $VER) -ge $(version "8.3.12.1469") ]; then

	#если x86_64
	if [ ${MACHINE_TYPE} == 'x86_64' ]; then

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\${PAKETNAME}_${VER1}.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        else

	#если x86
		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\${PAKET}_${VER1}.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')
        fi
    #Сравнение версий, если версия ниже 8.3.12.1469 качем отсюда
    else

        if [ ${MACHINE_TYPE} == 'x86_64' ]; then

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        else

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VER" \
		    --data-urlencode "path=Platform\\$VER1\\$PAKET.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        fi

    fi

fi

mkdir -p /tmp/dist1c

if [ $SERVER_CLIENT = "Клиент" ]; then

    if [ ${MACHINE_TYPE} == 'x86_64' ]; then
        echo
        echo -e "\e[1;33;4;44mЗакачиваем клиентскую часть версии для архитектуры $MACHINE_TYPE"
        echo
        curl -# --fail -b /tmp/cookies.txt -o /tmp/dist1c/${VER}.client64.tar.gz -L "$CLIENTLINK"
        echo
        echo -e "\e[1;33;4;44mЗакачиваем серверную часть версии для архитектуры $MACHINE_TYPE"
        echo
        curl -# --fail -b /tmp/cookies.txt -o /tmp/dist1c/${VER}.server64.tar.gz -L "$SERVERLINK"
        echo -e "\e[0m"
    else
        echo
        echo -e "\e[1;33;4;44mЗакачиваем клиентскую часть версии для архитектуры $MACHINE_TYPE"
        echo
        curl -# --fail -b /tmp/cookies.txt -o /tmp/dist1c/${VER}.client32.tar.gz -L "$CLIENTLINK"
        echo
        echo -e "\e[1;33;4;44mЗакачиваем серверную часть версии для архитектуры $MACHINE_TYPE"
        echo
        curl -# --fail -b /tmp/cookies.txt -o tmp/dist1c/${VER}.server32.tar.gz -L "$SERVERLINK"
        echo -e "\e[0m"
    fi
fi

if [ $SERVER_CLIENT = "Сервер" ]; then

    if [ ${MACHINE_TYPE} == 'x86_64' ]; then
        echo
        echo -e "\e[1;33;4;44mЗакачиваем серверную часть версии для архитектуры $MACHINE_TYPE"
        echo
        curl -# --fail -b /tmp/cookies.txt -o /tmp/dist1c/${VER}.server64.tar.gz -L "$SERVERLINK"
        echo -e "\e[0m"
    else
        echo
        echo -e "\e[1;33;4;44mЗакачиваем серверную часть версии для архитектуры $MACHINE_TYPE"
        echo
        curl -# --fail -b /tmp/cookies.txt -o tmp/dist1c/${VER}.server32.tar.gz -L "$SERVERLINK"
        echo -e "\e[0m"
    fi
fi

#удаляем файл с куки
rm /tmp/cookies.txt
#

#Распаковываем платформу 1C
echo -e "\e[1;33;4;44mРаспаковываем платформу 1C\e[0m"

#При установке клиента
if [ $SERVER_CLIENT = "Клиент" ]; then
    if [ ${MACHINE_TYPE} == 'x86_64' ]; then
        tar -xvf /tmp/dist1c/${VER}.client64.tar.gz -C /tmp/dist1c
        tar -xvf /tmp/dist1c/${VER}.server64.tar.gz -C /tmp/dist1c
        fi
    else
        tar -xvf /tmp/dist1c/${VER}.client32.tar.gz -C /tmp/dist1c
        tar -xvf /tmp/dist1c/${VER}.server32.tar.gz -C /tmp/dist1c
    fi
fi
#

#При установке сервера
if [ $SERVER_CLIENT = "Сервер" ]; then
    if [ ${MACHINE_TYPE} == 'x86_64' ]; then
        tar -xvf /tmp/dist1c/${VER}.server64.tar.gz -C /tmp/dist1c
        fi
    else
        tar -xvf /tmp/dist1c/${VER}.server32.tar.gz -C /tmp/dist1c
    fi
fi
#


#Удаляем tzr.gz
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    rm /tmp/dist1c/${VER}.client64.tar.gz
    rm /tmp/dist1c/${VER}.server64.tar.gz
else
    rm /tmp/dist1c/${VER}.client32.tar.gz
    rm /tmp/dist1c/${VER}.server32.tar.gz
fi
#

#Если Calculate-linux или gentoo
if [ $PAKETMANAGER = EMERGE ]; then
#Преобразовываем deb пакеты в tar.gz
echo -e "\e[1;33;4;44mПреобразовываем deb пакеты в tar.gz\e[0m"
deb2targz /tmp/dist1c/*.deb

#Удаляем deb пакеты
echo -e "\e[1;33;4;44mУдаляем deb пакеты\e[0m"
rm /tmp/dist1c/*.deb
#

#Перемещаем tar.gz в папку /var/calculate/remote/distfiles\
echo -e "\e[1;33;4;44mПеремещаем tar.gz в папку /var/calculate/remote/distfiles\e[0m"
mv /tmp/dist1c/*.tar.gz /var/calculate/remote/distfiles
#
echo -e "\e[1;33;4;44mТеперь выполните комманду по установке 1С клиента, например emerge 1c-enterprise83-client-$VER\e[0m"

#Устанавливаем или нет пакеты в систему
echo
echo -e "\e[1;31;42mУстановить программу?\e[0m"
echo
PS3='Установить программу? '
echo
select INSTALL in "Да" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $INSTALL\e[0m"
  echo
  break
done
    if [[ -z "$INSTALL" ]];then
    echo  -e "\e[31mНичего не указана\e[0m"
    exit 1
    fi

    if [ $INSTALL = "Да" ]; then
	if [ $SERVER_CLIENT = "Клиент" ]; then
#	    echo "1c-enterprise83-client-${VER}"
#	    emerge 
	fi
	if [ $SERVER_CLIENT = "Сервер" ]; then
#	    echo "1c-enterprise83-server-${VER}"
#	    emerge 
	fi
    fi

    if [ $INSTALL = "Нет" ]; then
#	    echo
    fi
fi
#

#Если дебиан
if [ $PAKETMANAGER = DEB ]; then

echo "Это Debian"

fi

#Если fedora
if [ $PAKETMANAGER = RPM ]; then

echo "Это Fedora"

fi



#удаляем папку
#rm -R /tmp/dist1c
#


