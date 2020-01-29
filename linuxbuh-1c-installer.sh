#!/bin/bash

#Колличество знаков # означают начало и конец определенной процедуры с наименованием, чем больше знаков - тем длиннее процедура

#Определяем архитектуру ядра Linux
MACHINE_TYPE=`uname -m`
if [ $MACHINE_TYPE == x86_64 ]; then
    OSBITVER=64
fi
if [ $MACHINE_TYPE == 32 ]; then
    OSBITVER=32
fi
#

#Определяем дистрибутив
source /etc/os-release
#source /tmp/os-release
OSRELEASE=$ID

echo -e "\e[1;33;4;44mВаш дистрибутив LINUX - $OSRELEASE\e[0m"
#

#Проверка существования файла с именем пользователя и паролем
FILE_USERNAME_PASSWORD=~/.userpassportal1cru
#

### если файл существует, берем из него данные
if [ -f $FILE_USERNAME_PASSWORD ]; then
echo -e "\e[33mФайл c именем пользователя и паролем существует.\e[0m"
source $FILE_USERNAME_PASSWORD
USERNAME=$USERNAME
PASSWORD=$PASSWORD
#

#Проверяем заполнение имени и пароля
    if [[ -z "$USERNAME" ]];then
        echo "Имя пользователя не указано"
        exit 1
    fi
    if [[ -z "$PASSWORD" ]];then
        echo "Пароль не указан"
        exit 1
    fi
#
else
#Меню ввода имени и пароля
echo -e "\e[1;31;42mВвод имени пользователя и пароля для сайта https://portal.1c.ru/ \e[0m"
echo
echo -n "Введите имя пользователя и нажмите [ENTER]: "
read USERNAME
echo -n "Введите пароль пользователя и нажмите [ENTER]:  "
read PASSWORD
echo
#
#Проверяем заполнение имени и пароля
    if [[ -z "$USERNAME" ]];then
        echo "Имя пользователя не указано"
        exit 1
    fi
    if [[ -z "$PASSWORD" ]];then
        echo "Пароль не указан"
        exit 1
    fi
##

#Меню - Сохранить имя и пароль
echo -e "\e[1;31;42mСохранить имя и пароль\e[0m"
echo
PS3='Сохранить имя и пароль (нажмите цифру 1-Да, 2-Нет) : '
echo
select SAVE_USERNAME_PASSWORD in "Да" "Нет"
do
  break
done
#

#Сохраняем имя и пароль
    if [ $SAVE_USERNAME_PASSWORD = "Да" ]; then
        echo USERNAME=$USERNAME >> $FILE_USERNAME_PASSWORD
        echo PASSWORD=$PASSWORD >> $FILE_USERNAME_PASSWORD
        echo
        echo -e "\e[1;31mВы выбрали $SAVE_USERNAME_PASSWORD, Ваше имя и пароль сохранены.\e[0m"
        echo
    else
        USERNAME=$USERNAME
        PASSWORD=$PASSWORD
        echo
        echo -e "\e[1;31mВы выбрали $SAVE_USERNAME_PASSWORD, Вам придется каждый раз снова вводить имя пользователя и пароль.\e[0m"
        echo
    fi
#
fi
###


#Выбор установки (обновления) платформы или конфигурации
echo
echo -e "\e[1;31;42mВыбор установки или обновления платформы (клиентской или серверной), или конфигурации 1С:Предприятие 8.3\e[0m"
echo
PS3='Выберите (нажмите цифру - например 1): '
echo
select VIBORGLAVMENU in "Платформа" "Конфигурация"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $VIBORGLAVMENU\e[0m"
  echo
  break
done
#
#Проверка
if [[ -z "$VIBORGLAVMENU" ]];then
    echo  -e "\e[31mВы не выбрали\e[0m"
    exit 1
fi
#

########################################################################## Платформа #########################################################################

if [ $VIBORGLAVMENU = "Платформа" ]; then

USERID=`id -u`

if [ $USERID == 0 ]; then
echo -e "\e[1;31;42mВы работаете как пользователь root\e[0m"
else
echo
echo -e "\e[1;31mВнимание - установка данной программы требует привилегий пользователя root\e[0m"
echo
echo -e "\e[1;31;42mВведите пароль пользователя root\e[0m"
echo
echo -n "Введите пароль пользователя и нажмите [ENTER]:  "
read PASSWORDROOT
fi

#Самостоятельно определить битность ОС
echo
echo -e "\e[1;31;42mСамостоятельно определить битность дистрибутива?\e[0m"
echo
PS3='Самостоятельно определить битность дистрибутива? '
echo
select OSBITVIBOR in "Да" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $OSBITVIBOR\e[0m"
  echo
  break
done
    if [[ -z "$OSBITVIBOR" ]];then
    echo  -e "\e[31mНичего не указана\e[0m"
    exit 1
    fi

    if [ $OSBITVIBOR = "Да" ]; then
	#Устанавливаем какие пакеты качать deb или rpm
	if [ $OSBITVER == 32 ]; then
	    OSBIT=32
	    BITPACKETVER=i386
	fi
	if [ $OSBITVER == 64 ]; then
	    OSBIT=64
	    BITPACKETVER=amd64
	fi
    fi

    if [ $OSBITVIBOR = "Нет" ]; then
    #пакетный менеджер
    echo
    echo -e "\e[1;31;42mВыбор вида битности пакетов\e[0m"
    echo
    PS3='Какие пакеты устанавливать x86_32 или x86_64 (нажмите 1 или 2)? '
    echo
    select BITPAKETVIBOR in "32" "64"
    do
      echo
      echo -e "\e[1;34;4mВы выбрали $BITPAKETVIBOR\e[0m"
      echo
      break
    done
    if [[ -z "$BITPAKETVIBOR" ]];then
        echo  -e "\e[31mБитность пакета не указана\e[0m"
        exit 1
    fi
    if [ $BITPAKETVIBOR == 32 ]; then
	    OSBIT=32
	    BITPACKETVER=i386
    fi
    if [ $BITPAKETVIBOR == 64 ]; then
	    OSBIT=64
	    BITPACKETVER=amd64
    fi
#
fi
#

echo -e "\e[1;33;4;44mВаш дистрибутив LINUX - $OSBIT\e[0m"
echo -e "\e[1;33;4;44mВаш дистрибутив LINUX - $BITPACKETVER\e[0m"


#Самостоятельно определить вид пакета или дать выбор пакетного менеджера
echo
echo -e "\e[1;31;42mСамостоятельно определить вид пакетов по типу пакетного менеджера?\e[0m"
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

read -i "8.3." -p "Выбирите версию для загрузки (введите два последних номера версии через точку - например 14.1565: " -e VERPLATFORM

if [[ -z "$VERPLATFORM" ]];then
    echo "VERSION не выбрана"
    exit 1
fi

if [[ "8.3." = "$VERPLATFORM" ]];then
    echo "Введен не полный номер версии VERSION"
    exit 1
fi
#

#Заменяем точки на нижнее подчеркивание в версии платформы
VERPLATFORM1=${VERPLATFORM//./_}
#

#Точки в версии платформы
VERPLATFORM2=${VERPLATFORM//./}
#

#Проверка на версию платформы 1С, все что равно и выше версии 8.3.12.1469. В версии 8.3.12.1469 на сайте 1С поменяли наименование пакетов для скачивания.
#Было наименование например client.deb64.tar.gz стало client_8_3_12_1469_deb64.tar.gz

#Функция для сравнения версий
function version_platform { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

#Если качаем клиент
if [ $SERVER_CLIENT = "Клиент" ]; then

    #Сравнение версий, если версия ниже 8.3.12.1469 то качаем после else
    if [ $(version_platform $VERPLATFORM) -ge $(version_platform "8.3.12.1469") ]; then

	#если x86_64
	if [ ${OSBIT} == '64' ]; then

		CLIENTLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\client_$VERPLATFORM1.$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\${PAKETNAME}_${VERPLATFORM1}.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        else

	#если x86
		CLIENTLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\client_$VERPLATFORM1.$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

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

		CLIENTLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
	    --data-urlencode "nick=Platform83" \
	    --data-urlencode "ver=$VERPLATFORM" \
	    --data-urlencode "path=Platform\\$VERPLATFORM1\\client.$PAKETNAME.tar.gz" \
	    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        else

		CLIENTLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\client.$PAKETNAME.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

		SERVERLINK=$(curl -s -G \
		    -b /tmp/cookies.txt \
		    --data-urlencode "nick=Platform83" \
		    --data-urlencode "ver=$VERPLATFORM" \
		    --data-urlencode "path=Platform\\$VERPLATFORM1\\$PAKET.tar.gz" \
		    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

        fi

    fi

fi

if [ $SERVER_CLIENT = "Сервер" ]; then

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

fi

#Директория для загрузки
UPLOADDIRPLATFORM=/tmp/Platform-$VERPLATFORM

mkdir -p $UPLOADDIRPLATFORM


if [ $SERVER_CLIENT = "Клиент" ]; then

    if [ ${OSBIT} == '64' ]; then
        echo
        echo -e "\e[1;33;4;44mЗакачиваем клиентскую часть версии для архитектуры $OSBIT"
        echo
        curl -# --fail -b /tmp/cookies.txt -o $UPLOADDIRPLATFORM/${VERPLATFORM}.client64.tar.gz -L "$CLIENTLINK"
        echo
        echo -e "\e[1;33;4;44mЗакачиваем серверную часть версии для архитектуры $OSBIT"
        echo
        curl -# --fail -b /tmp/cookies.txt -o $UPLOADDIRPLATFORM/${VERPLATFORM}.server64.tar.gz -L "$SERVERLINK"
        echo -e "\e[0m"
    else
        echo
        echo -e "\e[1;33;4;44mЗакачиваем клиентскую часть версии для архитектуры $OSBIT"
        echo
        curl -# --fail -b /tmp/cookies.txt -o $UPLOADDIRPLATFORM/${VERPLATFORM}.client32.tar.gz -L "$CLIENTLINK"
        echo
        echo -e "\e[1;33;4;44mЗакачиваем серверную часть версии для архитектуры $OSBIT"
        echo
        curl -# --fail -b /tmp/cookies.txt -o $UPLOADDIRPLATFORM/${VERPLATFORM}.server32.tar.gz -L "$SERVERLINK"
        echo -e "\e[0m"
    fi
fi

if [ $SERVER_CLIENT = "Сервер" ]; then

    if [ ${OSBIT} == '64' ]; then
        echo
        echo -e "\e[1;33;4;44mЗакачиваем серверную часть версии для архитектуры $OSBIT"
        echo
        curl -# --fail -b /tmp/cookies.txt -o $UPLOADDIRPLATFORM/${VERPLATFORM}.server64.tar.gz -L "$SERVERLINK"
        echo -e "\e[0m"
    else
        echo
        echo -e "\e[1;33;4;44mЗакачиваем серверную часть версии для архитектуры $OSBIT"
        echo
        curl -# --fail -b /tmp/cookies.txt -o $UPLOADDIRPLATFORM/${VERPLATFORM}.server32.tar.gz -L "$SERVERLINK"
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
    if [ ${OSBIT} == '64' ]; then
        tar -xvf $UPLOADDIRPLATFORM/${VERPLATFORM}.client64.tar.gz -C $UPLOADDIRPLATFORM
        tar -xvf $UPLOADDIRPLATFORM/${VERPLATFORM}.server64.tar.gz -C $UPLOADDIRPLATFORM
    else
        tar -xvf $UPLOADDIRPLATFORM/${VERPLATFORM}.client32.tar.gz -C $UPLOADDIRPLATFORM
        tar -xvf $UPLOADDIRPLATFORM/${VERPLATFORM}.server32.tar.gz -C $UPLOADDIRPLATFORM
    fi
fi
#

#При установке сервера
if [ $SERVER_CLIENT = "Сервер" ]; then
    if [ ${OSBIT} == '64' ]; then
        tar -xvf $UPLOADDIRPLATFORM/${VERPLATFORM}.server64.tar.gz -C $UPLOADDIRPLATFORM
    else
        tar -xvf $UPLOADDIRPLATFORM/${VERPLATFORM}.server32.tar.gz -C $UPLOADDIRPLATFORM
    fi
fi
#

#tar -xvf $UPLOADDIRPLATFORM/*.tar.gz -C $UPLOADDIRPLATFORM

#Удаляем tar.gz
rm $UPLOADDIRPLATFORM/*.tar.gz
#

#Если Calculate-linux или gentoo
if [ $PAKETMANAGER = EMERGE ]; then
#Преобразовываем deb пакеты в tar.gz
echo -e "\e[1;33;4;44mПреобразовываем deb пакеты в tar.gz\e[0m"
deb2targz $UPLOADDIRPLATFORM/*.deb

#Удаляем deb пакеты
echo -e "\e[1;33;4;44mУдаляем deb пакеты\e[0m"
rm $UPLOADDIRPLATFORM/*.deb
#

#Копируем tar.gz в папку /var/calculate/remote/distfiles\
#echo -e "\e[1;33;4;44mКопируем пакеты платформы в формате tar.gz в папку /var/calculate/remote/distfiles\e[0m"
#if [ $USERID == 0 ]; then
#cp $UPLOADDIRPLATFORM/*.tar.gz /var/calculate/remote/distfiles
#else
#echo $PASSWORDROOT | sudo -S cp $UPLOADDIRPLATFORM/*.tar.gz /var/calculate/remote/distfiles
#fi
#


#Устанавливаем или нет пакеты в систему
echo
echo -e "\e[1;31;42mУстановить программу?\e[0m"
echo
PS3='Установить программу? '
echo
select INSTALLPLATFORMEMERGE in "Да" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $INSTALLPLATFORMEMERGE\e[0m"
  echo
  break
done
    if [[ -z "$INSTALLPLATFORMEMERGE" ]];then
    echo  -e "\e[31mНичего не указано\e[0m"
    exit 1
    fi

    if [ $INSTALLPLATFORMEMERGE = "Да" ]; then
    VERPLATFORMSTIRE=`echo $VERPLATFORM | sed -re's/([[:digit:]]+\.[[:digit:]]+.[[:digit:]]+)\.([[:digit:]]+)/\1-\2/'`

	if [ $SERVER_CLIENT = "Клиент" ]; then
	echo -e "\e[1;34;4mУстанавливаем 1c-enterprise83-client-${VERPLATFORM}\e[0m"
	    if [ $USERID == 0 ]; then
		emerge =1c-enterprise83-client-${VERPLATFORM}
		emerge =1c-enterprise83-client-nls-${VERPLATFORM}
#	    tar -xvf $UPLOADDIRPLATFORM/1c-enterprise83-client_${VERPLATFORMSTIRE}_amd64.tar.gz -C /tmp/10
	    else
		echo $PASSWORDROOT | sudo -S emerge =1c-enterprise83-client-${VERPLATFORM}
		echo $PASSWORDROOT | sudo -S emerge =1c-enterprise83-client-nls-${VERPLATFORM}
#		echo $PASSWORDROOT | sudo -S tar -xvf $UPLOADDIRPLATFORM/1c-enterprise83-client_${VERPLATFORMSTIRE}_amd64.tar.gz -C /tmp/10
	    fi
	fi
	if [ $SERVER_CLIENT = "Сервер" ]; then
        #Устанавливаем или нет Postgres
        echo
        echo -e "\e[1;31;42mУстановить Postgres?\e[0m"
        echo
        PS3='Установить Postgres? :'
        echo
        select INSTALLPLATFORMEMERGEPOSTGRES in "Да" "Нет"
        do
	    echo
	    echo -e "\e[1;34;4mВы выбрали $INSTALLPLATFORMEMERGEPOSTGRES\e[0m"
	    echo
	break
	done
		if [[ -z "$INSTALLPLATFORMEMERGEPOSTGRES" ]];then
	        echo  -e "\e[31mНичего не указано\e[0m"
		exit 1
		fi
		if [ $INSTALLPLATFORMEMERGEPOSTGRES = "Да" ]; then
		    echo -e "\e[1;34;4mУстанавливаем Postgres\e[0m"
			if [ $USERID == 0 ]; then
			    USE="server postgres" emerge =1c-enterprise83-server-${VERPLATFORM}
			    emerge =1c-enterprise83-server-nls-${VERPLATFORM}
			else
			    echo $PASSWORDROOT | sudo -S USE="server postgres" emerge =1c-enterprise83-server-${VERPLATFORM}
			    echo $PASSWORDROOT | sudo -S emerge =1c-enterprise83-server-nls-${VERPLATFORM}
			fi
		fi
		if [ $INSTALLPLATFORMEMERGEPOSTGRES = "Нет" ]; then
		        echo -e "\e[1;33;4;44mТеперь выполните комманду по установке 1С , например emerge =\e[0m"
		fi
		    #Устанавливаем или нет WEB компоненту 1С Сервер
		    echo
		    echo -e "\e[1;31;42mУстановить программу?\e[0m"
		    echo
		    PS3='Установить WEB компоненту 1С Сервер? :'
		    echo
		    select INSTALLPLATFORMEMERGEWEB1C in "Да" "Нет"
		    do
		      echo
		      echo -e "\e[1;34;4mВы выбрали $INSTALLPLATFORMEMERGEWEB1C\e[0m"
		      echo
		      break
		    done
			if [[ -z "$INSTALLPLATFORMEMERGEWEB1C" ]];then
		        echo  -e "\e[31mНичего не указано\e[0m"
			    exit 1
		        fi
			if [ $INSTALLPLATFORMEMERGEWEB1C = "Да" ]; then
			echo -e "\e[1;34;4mУстанавливаем 1c-enterprise83-ws-${VERPLATFORM}\e[0m"
			    if [ $USERID == 0 ]; then
				USE"server" emerge =1c-enterprise83-ws-${VERPLATFORM}
				emerge =1c-enterprise83-ws-nls-${VERPLATFORM}
			    else
				echo $PASSWORDROOT | sudo -S USE"server" emerge =1c-enterprise83-ws-${VERPLATFORM}
				echo $PASSWORDROOT | sudo -S emerge =1c-enterprise83-ws-nls-${VERPLATFORM}
			    fi
			fi
		    
		        if [ $INSTALLPLATFORMEMERGEWEB1C = "Нет" ]; then
		        echo -e "\e[1;33;4;44mТеперь выполните комманду по установке 1С , например emerge =1c-enterprise83-ws-$VERPLATFORM\e[0m"
		        fi

	fi
    fi

    if [ $INSTALLPLATFORMEMERGE = "Нет" ]; then
    echo -e "\e[1;33;4;44mТеперь выполните комманду по установке 1С клиента, например emerge =1c-enterprise83-client-$VERPLATFORM или emerge =1c-enterprise83-server-$VERPLATFORM\e[0m"
    fi
fi
#

#Если DEB
if [ $PAKETMANAGER = DEB ]; then

#Устанавливаем или нет пакеты в систему
echo
echo -e "\e[1;31;42mУстановить программу?\e[0m"
echo
PS3='Установить программу? '
echo
select INSTALLPLATFORMDEB in "Да" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $INSTALLPLATFORMDEB\e[0m"
  echo
  break
done
    if [[ -z "$INSTALLPLATFORMDEB" ]];then
    echo  -e "\e[31mНичего не указано\e[0m"
    exit 1
    fi

    if [ $INSTALLPLATFORMDEB = "Да" ]; then
	if [ $SERVER_CLIENT = "Клиент" ]; then
	echo -e "\e[1;34;4mУстанавливаем 1c-enterprise83-client-${VERPLATFORM}\e[0m"
	    if [ $USERID == 0 ]; then
		dpkg -i 1c-enterprise83-common
		dpkg -i 1c-enterprise83-common-nls
		dpkg -i 1c-enterprise83-server
		dpkg -i 1c-enterprise83-server-nls
		dpkg -i 1c-enterprise83-client
		dpkg -i 1c-enterprise83-client-nls
	    else
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-common
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-common-nls
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-server
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-server-nls
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-client
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-client-nls
	    fi
	fi
	if [ $SERVER_CLIENT = "Сервер" ]; then
	echo -e "\e[1;34;4mУстанавливаем 1c-enterprise83-server-${VERPLATFORM}\e[0m"
	    if [ $USERID == 0 ]; then
		dpkg -i 1c-enterprise83-common_$VERPLATFORM.$PAKETNAME
		dpkg -i 1c-enterprise83-common-nls_$VERPLATFORM.$PAKETNAME
		dpkg -i 1c-enterprise83-server_$VERPLATFORM.$PAKETNAME
		dpkg -i 1c-enterprise83-server-nls_${VERPLATFORM}_
	    else
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-common_$VERPLATFORM.$PAKETNAME
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-common-nls_$VERPLATFORM.$PAKETNAME
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-server_$VERPLATFORM.$PAKETNAME
		echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-server-nls_${VERPLATFORM}_
	    fi
	    
		    #Устанавливаем или нет WEB компоненту 1С Сервер
		    echo
		    echo -e "\e[1;31;42mУстановить программу?\e[0m"
		    echo
		    PS3='Установить WEB компоненту 1С Сервер? :'
		    echo
		    select INSTALLPLATFORMDEBWEB1C in "Да" "Нет"
		    do
		      echo
		      echo -e "\e[1;34;4mВы выбрали $INSTALLPLATFORMDEBWEB1C\e[0m"
		      echo
		      break
		    done
			if [[ -z "$INSTALLPLATFORMDEBWEB1C" ]];then
		        echo  -e "\e[31mНичего не указано\e[0m"
			    exit 1
		        fi
			if [ $INSTALLPLATFORMDEBWEB1C = "Да" ]; then
			echo -e "\e[1;34;4mУстанавливаем 1c-enterprise83-ws-${VERPLATFORM}\e[0m"
			    if [ $USERID == 0 ]; then
				dpkg -i 1c-enterprise83-ws
				dpkg -i 1c-enterprise83-ws-nls
			    else
				echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-ws
				echo $PASSWORDROOT | sudo -S dpkg -i 1c-enterprise83-ws-nls
			    fi
			fi
		    
		        if [ $INSTALLPLATFORMDEBWEB1C = "Нет" ]; then
		        echo -e "\e[1;33;4;44mТеперь выполните комманду по установке 1С клиента, например dpkg -i 1c-enterprise83-ws-$VERPLATFORM\e[0m"
		        fi

	fi

    fi

    if [ $INSTALLPLATFORM = "Нет" ]; then
    echo -e "\e[1;33;4;44mТеперь выполните комманду по установке 1С клиента, например dpkg -i 1c-enterprise83-client-$VERPLATFORM или dpkg -i 1c-enterprise83-server-$VERPLATFORM\e[0m"
    fi


fi

#Если RPM
if [ $PAKETMANAGER = RPM ]; then

#Устанавливаем или нет пакеты в систему
echo
echo -e "\e[1;31;42mУстановить программу?\e[0m"
echo
PS3='Установить программу? '
echo
select INSTALLPLATFORMRPM in "Да" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $INSTALLPLATFORMRPM\e[0m"
  echo
  break
done
    if [[ -z "$INSTALLPLATFORMRPM" ]];then
    echo  -e "\e[31mНичего не указано\e[0m"
    exit 1
    fi

    if [ $INSTALLPLATFORMRPM = "Да" ]; then
	if [ $SERVER_CLIENT = "Клиент" ]; then
	echo -e "\e[1;34;4mУстанавливаем 1c-enterprise83-client-${VERPLATFORM}\e[0m"
	    if [ $USERID == 0 ]; then
		yum -y 1c-enterprise83-common
		yum -y 1c-enterprise83-common-nls
		yum -y 1c-enterprise83-server
		yum -y 1c-enterprise83-server-nls
		yum -y 1c-enterprise83-client
		yum -y 1c-enterprise83-client-nls
	    else
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-common
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-common-nls
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-server
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-server-nls
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-client
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-client-nls
	    fi
	fi
	if [ $SERVER_CLIENT = "Сервер" ]; then
	echo -e "\e[1;34;4mУстанавливаем 1c-enterprise83-server-${VERPLATFORM}\e[0m"
	    if [ $USERID == 0 ]; then
		yum -y 1c-enterprise83-common
		yum -y 1c-enterprise83-common-nls
		yum -y 1c-enterprise83-server
		yum -y 1c-enterprise83-server-nls
	    else
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-common
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-common-nls
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-server
		echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-server-nls
	    fi
	    
		    #Устанавливаем или нет WEB компоненту 1С Сервер
		    echo
		    echo -e "\e[1;31;42mУстановить WEB компоненту 1С Сервер?\e[0m"
		    echo
		    PS3='Установить WEB компоненту 1С Сервер? :'
		    echo
		    select INSTALLPLATFORMRPMWEB1C in "Да" "Нет"
		    do
		      echo
		      echo -e "\e[1;34;4mВы выбрали $INSTALLPLATFORMRPMWEB1C\e[0m"
		      echo
		      break
		    done
			if [[ -z "$INSTALLPLATFORMRPMWEB1C" ]];then
		        echo  -e "\e[31mНичего не указано\e[0m"
			    exit 1
		        fi
			#
			if [ $INSTALLPLATFORMRPMWEB1C = "Да" ]; then
			echo -e "\e[1;34;4mУстанавливаем 1c-enterprise83-ws-${VERPLATFORM}\e[0m"
			    if [ $USERID == 0 ]; then
				yum -y 1c-enterprise83-ws
				yum -y 1c-enterprise83-ws-nls
			    else
				echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-ws
				echo $PASSWORDROOT | sudo -S yum -y 1c-enterprise83-ws-nls
			    fi
			fi
			#
		        if [ $INSTALLPLATFORMRPMBWEB1C = "Нет" ]; then
		        echo -e "\e[1;33;4;44mТеперь выполните комманду по установке 1С клиента, например yum -y 1c-enterprise83-ws-$VERPLATFORM\e[0m"
		        fi
			#
	fi
	#
    fi
    #
    if [ $INSTALLPLATFORMRPM = "Нет" ]; then
    echo -e "\e[1;33;4;44mТеперь выполните комманду по установке 1С клиента, например yum -y 1c-enterprise83-client-$VERPLATFORM или yum -y 1c-enterprise83-server-$VERPLATFORM\e[0m"
    fi
    #
fi
#

#Удалить файлы платформы или нет
echo
echo -e "\e[1;31;42mУдалить файлы платформы?\e[0m"
echo
PS3='Выберите (нажмите цифру - например 1): '
echo

select DELFILESVIBORPLATFORM in "Удалить" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $DELFILESVIBORPLATFORM\e[0m"
  echo
  break
done

if [[ -z "$DELFILESVIBORPLATFORM" ]];then
    echo  -e "\e[31mНе указан выбор 5\e[0m"
    exit 1
fi

if [ $DELFILESVIBORPLATFORM = "Удалить" ]; then
    rm -R $UPLOADDIRPLATFORM
    exit 0
fi

if [ $DELFILESVIBORPLATFORM = "Нет" ]; then

    #Скопировать файлы
    echo -e "\e[1;33;4;44mФайлы могут быть скопированы в домашний каталог пользователя в папку 1C_arhiv\e[0m"
    echo
    echo -e "\e[1;31;42mСкопировать файлы?\e[0m"
    echo
    PS3='Выберите (нажмите цифру - например 1): '
    echo

    select COPYFILESVIBORPLATFORM in "Да" "Нет"
    do
      echo
      echo -e "\e[1;34;4mВы выбрали $COPYFILESVIBORPLATFORM\e[0m"
      echo
      break
    done


    if [[ -z "$COPYFILESVIBORPLATFORM" ]];then
        echo  -e "\e[31mНе указан выбор 6\e[0m"
        exit 1
    fi

    if [ $COPYFILESVIBORPLATFORM = "Да" ]; then
        read -i "~/1C_arhiv/Platform-$VERPLATFORM" -p "Введите путь для сохранения или оставте текущий: " -e COPYPATHPLATFORM
#	echo
#	echo -n "Введите путь для сохранения нажмите [ENTER]: "
#	read USERNAME
        mkdir $COPYPATHPLATFORM
        cp -R $UPLOADDIRPLATFORM $COPYPATHPLATFORM
        rm -R $UPLOADDIRPLATFORM
        echo "Все скачанные файлы скопированы в папку пользователя в каталог $COPYPATHPLATFORM"

        exit 0
    fi

    if [ $COPYFILESVIBORPLATFORM = "Нет" ]; then
        echo "Все скачанные файлы остались в каталоге $UPLOADDIRPLATFORM"
        exit 0
    fi

fi

fi
#

############################################################################### Конфигурация ##############################################################

#Выбор конфигурации
if [ $VIBORGLAVMENU = "Конфигурация" ]; then
echo
echo -e "\e[1;31;42mВыбор конфигурации\e[0m"
echo
PS3='Выберите конфигурацию: '
echo
select CONFVIBOR in "Управление_Торговлей_11" "Бухгалтерия_Предприятия_3_0_ПРОФ" "Зарплата_и_Управление_Персоналом_3"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $CONFVIBOR\e[0m"
  echo
  break
done
    if [[ -z "$CONFVIBOR" ]];then
    echo  -e "\e[31mКонфигурация не указана\e[0m"
    exit 1
    fi

    if [ $CONFVIBOR = "Управление_Торговлей_11" ]; then
    CONF=Trade
    CONFVER=110
    CONFVERSION=$CONF$CONFVER
    fi

    if [ $CONFVIBOR = "Бухгалтерия_Предприятия_3_0_ПРОФ" ]; then
    CONF=Accounting
    CONFVER=30
    CONFVERSION=$CONF$CONFVER
    fi

    if [ $CONFVIBOR = "Зарплата_и_Управление_Персоналом_3" ]; then
    CONF=HRM
    CONFVER=30
    CONFVERSION=$CONF$CONFVER
    fi
#
#Выбор обновление или установка

#Если Управление торговли 11
if [ $CONFVERSION = Trade110 ]; then
#Выбор обновление или установка
echo
echo -e "\e[1;31;42mВыбор обновления или установки\e[0m"
echo
PS3='Выберите (нажмите цифру - например 1): '
echo

select SETUPVIBOR in "Установка" "Обновление" "Обновление_с_базовой_версии"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $SETUPVIBOR\e[0m"
  echo
  break
done


    if [[ -z "$SETUPVIBOR" ]];then
    echo  -e "\e[31mНе указан выбор 2\e[0m"
    exit 1
    fi

    if [ $SETUPVIBOR = "Установка" ]; then
    SETUP=setup1c
    fi

    if [ $SETUPVIBOR = "Обновление" ]; then
    SETUP=updsetup
    fi

    if [ $SETUPVIBOR = "Обновление_с_базовой_версии" ]; then
    SETUP=updstpb
    fi

fi

#Если Бухгалтерия предприятия 3.0
if [ $CONFVERSION = Accounting30 ]; then
#Выбор обновление или установка
echo
echo -e "\e[1;31;42mВыбор обновления или установки\e[0m"
echo
PS3='Выберите (нажмите цифру - например 1): '
echo

select SETUPVIBOR in "Установка" "Обновление" "Обновление_с_базовой_версии" "Обновление_с_базовой_версии_для_1" "Обновление_с_редакции_2_0"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $SETUPVIBOR\e[0m"
  echo
  break
done


    if [[ -z "$SETUPVIBOR" ]];then
    echo  -e "\e[31mНе указан выбор 3\e[0m"
    exit 1
    fi

    if [ $SETUPVIBOR = "Установка" ]; then
    SETUP=setup1c
    fi

    if [ $SETUPVIBOR = "Обновление" ]; then
    SETUP=updsetup
    fi

    if [ $SETUPVIBOR = "Обновление_с_базовой_версии" ]; then
    SETUP=updstpb
    fi

    if [ $SETUPVIBOR = "Обновление_с_базовой_версии_для_1" ]; then
    SETUP=updstpbo
    fi

    if [ $SETUPVIBOR = "Обновление_с_редакции_2_0" ]; then
    SETUP=updstp_20
    fi

fi

#Если Зарплата и управление персоналом 3
if [ $CONFVERSION = HRM30 ]; then
#Выбор обновление или установка
echo
echo -e "\e[1;31;42mВыбор обновления или установки\e[0m"
echo
PS3='Выберите (нажмите цифру - например 1): '
echo

select SETUPVIBOR in "Установка" "Обновление" "Обновление_с_базовой_версии"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $SETUPVIBOR\e[0m"
  echo
  break
done

    if [[ -z "$SETUPVIBOR" ]];then
    echo  -e "\e[31mНе указан выбор 4\e[0m"
    exit 1
    fi

    if [ $SETUPVIBOR = "Установка" ]; then
    SETUP=setup1c
    fi

    if [ $SETUPVIBOR = "Обновление" ]; then
    SETUP=updsetup
    fi

    if [ $SETUPVIBOR = "Обновление_с_базовой_версии" ]; then
    SETUP=updstpb
    fi

fi

echo "$CONFVERSION"
echo "$SETUPVIBOR"

#Начинаем работу
echo
echo -e "\e[1;33;4;44mПодождите. Начинаем работать. Подключаемся к серверу 1С\e[0m"
echo
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

#clear
echo
echo -e "\e[31;42mСписок версий для загрузки\e[0m"
echo

curl -s -b /tmp/cookies.txt https://releases.1c.ru/project/$CONFVERSION |

    grep 'a href="/version_files?nick='$CONFVERSION'' |
    tr -s '="  ' ' ' |
    awk -F ' ' '{print $5}' |
    sort -Vr | pr -T -6

if [ $CONFVERSION = Trade110 ]; then
read -p "Выбирите версию для загрузки (введите номер версии через точку - например 11.4.6.207: " -e VERCONF
fi

if [ $CONFVERSION = Accounting30 ]; then
read -p "Выбирите версию для загрузки (введите номер версии через точку - например 3.0.67.74: " -e VERCONF
fi

if [ $CONFVERSION = HRM30 ]; then
read -p "Выбирите версию для загрузки (введите номер версии через точку - например 3.1.8.246: " -e VERCONF
fi


if [[ -z "$VERCONF" ]];then
    echo "VERSION not set"
    exit 1
fi

if [[ "" = "$VERCONF" ]];then
    echo "Need full VERSION number"
    exit 1
fi

#Убираем точки из версии
VERCONF0=${VERCONF//./}
#Заменяем точки на нижнее подчеркивание в версии
VERCONF1=${VERCONF//./_}
#Подмена версии
VERCONF4=${VERCONF//./_}_$SETUP

#Директория для загрузки
UPLOADDIRCONF=/tmp/$CONFVERSION-$SETUP-$VERCONF

#Преобразовываем номер версии для сравнения
function version_conf { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

#Управление Торговлей 11
if [ $CONFVERSION = Trade110 ]; then

    if [ $(version_conf $VERCONF) -ge $(version_conf "11.3.4.228") ]; then

    CONFLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VERCONF" \
    --data-urlencode "path=$CONF\\$VERCONF1\\${CONF}_${VERCONF4}.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

    else

    CONFLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VERCONF" \
    --data-urlencode "path=$CONF\\$VERCONF1\\$SETUP.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

    fi

fi

#Бухгалтерия предприятия 3.0 ПРОФ
if [ $CONFVERSION = Accounting30 ]; then

    if [ $(version_conf $VERCONF) -ge $(version_conf "3.0.61.37") ]; then

    CONFLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VERCONF" \
    --data-urlencode "path=$CONF\\$VERCONF1\\${CONF}_${VERCONF4}.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

    else

    CONFLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VERCONF" \
    --data-urlencode "path=$CONF\\$VERCONF1\\$SETUP.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

    fi

fi

#Зарплата и управление персоналом 3 ПРОФ
if [ $CONFVERSION = HRM30 ]; then

    if [ $(version_conf $VERCONF) -ge $(version_conf "3.1.6.38") ]; then

    CONFLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VERCONF" \
    --data-urlencode "path=$CONF\\$VERCONF1\\${CONF}_${VERCONF4}.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

    else

    CONFLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VERCONF" \
    --data-urlencode "path=$CONF\\$VERCONF1\\$SETUP.exe" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив с зеркала 2)')

    fi

fi


#Качаем файл
mkdir -p $UPLOADDIRCONF

echo
echo -e "\e[1;33;4;44mКачаем файл ${CONF}_${VERCONF4}"
curl -# --fail -b /tmp/cookies.txt -o $UPLOADDIRCONF/${CONF}_${VERCONF4}.exe -L "$CONFLINK"
echo -e "\e[0m"

rm /tmp/cookies.txt

#Распаковываем
echo
echo -e "\e[1;33;4;44mРаспаковываем exe файл\e[0m"
echo
cd $UPLOADDIRCONF
unrar e $UPLOADDIRCONF/${CONF}_${VERCONF4}.exe
rm $UPLOADDIRCONF/${CONF}_${VERCONF4}.exe

#Запускаем установщик
echo
echo -e "\e[1;33;4;44mЗапускаем установщик\e[0m"
echo
cd $UPLOADDIRCONF
chmod 777 $UPLOADDIRCONF/setup
sh $UPLOADDIRCONF/setup

#Удалить файлы или нет
echo
echo -e "\e[1;31;42mУдалить файлы?\e[0m"
echo
PS3='Выберите (нажмите цифру - например 1): '
echo

select DELFILESVIBORCONF in "Удалить" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $DELFILESVIBORCONF\e[0m"
  echo
  break
done

if [[ -z "$DELFILESVIBORCONF" ]];then
    echo  -e "\e[31mНе указан выбор 5\e[0m"
    exit 1
fi

if [ $DELFILESVIBORCONF = "Удалить" ]; then
    rm -R $UPLOADDIRCONF
    exit 0
fi

if [ $DELFILESVIBORCONF = "Нет" ]; then

    #Скопировать файлы
    echo -e "\e[1;33;4;44mФайлы могут быть скопированы в домашний каталог пользователя в папку 1C_arhiv\e[0m"
    echo
    echo -e "\e[1;31;42mСкопировать файлы?\e[0m"
    echo
    PS3='Выберите (нажмите цифру - например 1): '
    echo

    select COPYFILESVIBORCONF in "Да" "Нет"
    do
      echo
      echo -e "\e[1;34;4mВы выбрали $COPYFILESVIBORCONF\e[0m"
      echo
      break
    done


    if [[ -z "$COPYFILESVIBORCONF" ]];then
        echo  -e "\e[31mНе указан выбор 6\e[0m"
        exit 1
    fi

    if [ $COPYFILESVIBORCONF = "Да" ]; then
        mkdir ~/1C_arhiv
        cp -R $UPLOADDIRCONF ~/1C_arhiv/$CONFVERSION-$SETUP-$VERCONF
        rm -R $UPLOADDIRCONF
        echo "Все скачанные файлы скопированы в папку пользователя в каталог /1C_arhiv/$CONFVERSION-$SETUP-$VERCONF"
        exit 0
    fi

    if [ $COPYFILESVIBORCONF = "Нет" ]; then
        echo "Все скачанные файлы остались в папке $UPLOADDIRCONF"
        exit 0
    fi

fi

fi
#