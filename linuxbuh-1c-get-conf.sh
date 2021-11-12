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

#Выбор конфигурации
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
read -p "Выбирите версию для загрузки (введите номер версии через точку - например 11.4.6.207: " -e VER
fi

if [ $CONFVERSION = Accounting30 ]; then
read -p "Выбирите версию для загрузки (введите номер версии через точку - например 3.0.67.74: " -e VER
fi

if [ $CONFVERSION = HRM30 ]; then
read -p "Выбирите версию для загрузки (введите номер версии через точку - например 3.1.8.246: " -e VER
fi


if [[ -z "$VER" ]];then
    echo "VERSION not set"
    exit 1
fi

if [[ "" = "$VER" ]];then
    echo "Need full VERSION number"
    exit 1
fi

#Убираем точки из версии
VER0=${VER//./}
#Заменяем точки на нижнее подчеркивание в версии
VER1=${VER//./_}
#Подмена версии
VER4=${VER//./_}_$SETUP

#Директория для загрузки
UPLOADDIR=/tmp/$CONFVERSION-$SETUP-$VER

#Преобразовываем номер версии для сравнения
function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

#Управление Торговлей 11
if [ $CONFVERSION = Trade110 ]; then

    if [ $(version $VER) -ge $(version "11.3.4.228") ]; then

    CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=$CONF\\$VER1\\${CONF}_${VER4}.exe" \
    https://releases.1c.ru/version_file | grep -m 1 -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

    else

    CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=$CONF\\$VER1\\$SETUP.exe" \
    https://releases.1c.ru/version_file | grep -m 1 -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

    fi

fi

#Бухгалтерия предприятия 3.0 ПРОФ
if [ $CONFVERSION = Accounting30 ]; then

    if [ $(version $VER) -ge $(version "3.0.61.37") ]; then

    CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=$CONF\\$VER1\\${CONF}_${VER4}.exe" \
    https://releases.1c.ru/version_file | grep -m 1 -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

    else

    CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=$CONF\\$VER1\\$SETUP.exe" \
    https://releases.1c.ru/version_file | grep -m 1 -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

    fi

fi

#Зарплата и управление персоналом 3 ПРОФ
if [ $CONFVERSION = HRM30 ]; then

    if [ $(version $VER) -ge $(version "3.1.6.38") ]; then

    CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=$CONF\\$VER1\\${CONF}_${VER4}.exe" \
    https://releases.1c.ru/version_file | grep -m 1 -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

    else

    CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=$CONFVERSION" \
    --data-urlencode "ver=$VER" \
    --data-urlencode "path=$CONF\\$VER1\\$SETUP.exe" \
    https://releases.1c.ru/version_file | grep -m 1 -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

    fi

fi


#Качаем файл
mkdir -p $UPLOADDIR

echo
echo -e "\e[1;33;4;44mКачаем файл $CONF_$VER4"
curl -# --fail -b /tmp/cookies.txt -o $UPLOADDIR/$CONF_$VER4.exe -L "$CLIENTLINK"
echo -e "\e[0m"

rm /tmp/cookies.txt

#Распаковываем
echo
echo -e "\e[1;33;4;44mРаспаковываем exe файл\e[0m"
echo
cd $UPLOADDIR
unrar e $CONF_$VER4.exe
rm $CONF_$VER4.exe

#Запускаем установщик
echo
echo -e "\e[1;33;4;44mЗапускаем установщик\e[0m"
echo

chmod 777 setup
sh setup

#Удалить файлы или нет
echo
echo -e "\e[1;31;42mУдалить файлы?\e[0m"
echo
PS3='Выберите (нажмите цифру - например 1): '
echo

select DELFILESVIBOR in "Удалить" "Нет"
do
  echo
  echo -e "\e[1;34;4mВы выбрали $DELFILESVIBOR\e[0m"
  echo
  break
done

if [[ -z "$DELFILESVIBOR" ]];then
    echo  -e "\e[31mНе указан выбор 5\e[0m"
    exit 1
fi

if [ $DELFILESVIBOR = "Удалить" ]; then
    rm -R $UPLOADDIR
    exit 0
fi

if [ $DELFILESVIBOR = "Нет" ]; then

    #Скопировать файлы
    echo -e "\e[1;33;4;44mФайлы могут быть скопированы в домашний каталог пользователя в папку 1C_arhiv\e[0m"
    echo
    echo -e "\e[1;31;42mСкопировать файлы?\e[0m"
    echo
    PS3='Выберите (нажмите цифру - например 1): '
    echo

    select COPYFILESVIBOR in "Да" "Нет"
    do
      echo
      echo -e "\e[1;34;4mВы выбрали $COPYFILESVIBOR\e[0m"
      echo
      break
    done


    if [[ -z "$COPYFILESVIBOR" ]];then
        echo  -e "\e[31mНе указан выбор 6\e[0m"
        exit 1
    fi

    if [ $COPYFILESVIBOR = "Да" ]; then
        mkdir ~/1C_arhiv
#        mkdir ~/1C_arhiv/$CONFVERSION-$SETUP-$VER
        cp -R $UPLOADDIR ~/1C_arhiv/$CONFVERSION-$SETUP-$VER
        rm -R $UPLOADDIR
        exit 0
    fi

    if [ $COPYFILESVIBOR = "Нет" ]; then
        exit 0
    fi

fi
