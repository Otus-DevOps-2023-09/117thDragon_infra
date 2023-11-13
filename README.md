# 117thDragon_infra
117thDragon Infra repository

<<<<<<< HEAD
=======
###HW №3###
bastion_IP = 158.160.98.52
someinternalhost_IP = 10.128.0.33
>>>>>>> 34dd654 (correct)

# HW №3
```
bastion_IP = 158.160.98.52
someinternalhost_IP = 10.128.0.33
```
## Дополнительное задание №1
1. Подключение к локальному серверу (`someinternalhost`) через сервер `Basion`:
```
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/appuser && ssh -i ~/.ssh/appuser -A appuser@basion-host-ip && ssh appuser@remote-local-host-ip
```
2. Или более правильный вариант подключения к локальным VM's (хостам) с использованием авторизации ssh-key через `SSH-Jump` сервер `bastion`:
```
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
```
3. Сквозное подключение:
```
ssh -J bastion someinternalhost
or
ssh someinternalhost cloud-bastion
```
##Дополнительное задание №2
#Использование сервиса nip.io и встроенного в "Pritunl" Let's Encrypt

## Дополнительное задание №2
4. Использование сервиса `npo.io` и встроенного в `Pritunl` Let's Encrypt. Регистрируем запись в `npo.io`:
```
curl -vvv bastion.<ip>.nip.io
```
5. Далее в панели управления `Pritunl` переходи в раздел `Settings` и вносим в поле `Lets Encrypt Domain` ранее зарегистрированное DN, после чего созраняем настройку. Сертификат будет выпущен и автоматически установлен для работы для работы web-интерфейса по протоколу `https`. `p.s`. На момент выполнения работы, сервер `Let's Encrypt` отказывался выпускать сертификат по причине: `Error creating new order :: too many certificates already issued for \"nip.io\`.
