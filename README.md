# 117thDragon_infra
117thDragon Infra repository

###HW №3###
bastion_IP = 158.160.127.176
someinternalhost_IP = 10.128.0.19

##Дополнительное задание №1
#Подключение к локальному серверу (someinternalhost) через сервер Basion:
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/appuser && ssh -i ~/.ssh/appuser -A appuser@basion-host-ip && ssh appuser@remote-local-host-ip

#Или более правильный вариант подключения к локальным VM's (хостам) с использованием авторизации ssh-key через SSH-Jump сервер bastion:
nano  ~/.ssh/config
Host bastion
        Hostname <ip-bastion>
        User appuser
        Port 22
        IdentityFile ~/.ssh/appuser
Host someinternalhost
        Hostname <ip-local-host>
        User appuser
	IdentityFile ~/.ssh/appuser
	ProxyJump appuser@bastion
#Сквозное подключение:
ssh -J bastion someinternalhost
or
ssh someinternalhost

##Дополнительное задание №2
#Использование сервиса npo.io и встроенного в "Pritunl" Let's Encrypt
#Регистрируем запись в npo.io:
curl -vvv bastion.<ip>.nip.io

Далее в панели управления "Pritunl" переходи в раздел "Settings" и вносим в поле "Lets Encrypt Domain" ранее зарегистрированное DN, после чего созраняем настройку.
Сертификат будет выпущен и автоматически установлен для работы для работы web-интерфейса по протоколу "https".
p.s. На момент выполнения работы, сервер Let's Encrypt отказывался выпускать сертификат по причине: "Error creating new order :: too many certificates already issued for \"nip.io\".

###HW №4###
testapp_IP = 158.160.124.82
testapp_port = 9292

#Доступ к приложению
http://158.160.124.82:9292/

##Дополнительное задание №1
startup_script.sh - shell-скрипт создания инстанса
metadata.yaml - файл с метаданными для настройки инстанса
