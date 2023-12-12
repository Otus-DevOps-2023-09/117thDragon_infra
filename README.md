# 117thDragon_infra
117thDragon Infra repository

=======
# HW №3
```
bastion_IP = 158.160.98.52
someinternalhost_IP = 10.128.0.20
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


# HW №4
```
testapp_IP = 51.250.91.149
testapp_port = 9292
```
1. Создание инстанса
```
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata-from-file user-data=metadata.yaml \
  --metadata serial-port-enable=1
```
2. Доступ к приложению
```
http://51.250.91.149:9292/
```
## Дополнительное задание №1
```
startup_script.sh - shell-скрипт создания инстанса
metadata.yaml - файл с метаданными для настройки инстанса
```


# HW №5
1. Установка packer:
```
wget https://hashicorp-releases.yandexcloud.net/packer/1.9.4/packer_1.9.4_linux_amd64.zip
sudo apt install zip unzip
sudo unzip packer_1.9.4_linux_amd64.zip
sudo mv packer /usr/local/bin/
packer -v
```
2. Создание сервисного аккаунта yandex cloud:
```
yc config list | grep folder-id
SVC_ACCT="svc-acc"
FOLDER_ID="*************"
yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
```
3. Присвоение роли "Editor" в текущем каталоге:
```
ACCT_ID=$(yc iam service-account get $SVC_ACCT | \
grep ^id | \
awk '{print $2}')

yc resource-manager folder add-access-binding --id $FOLDER_ID \
--role editor \
--service-account-id $ACCT_ID
```
4. Экспорт ключа сервисаного аккаунта в файл:
```
yc iam key create --service-account-id $ACCT_ID --output ./key.json
```
5. Создан шаблон packer - ubuntu16.json.
```
1) Выполнение команды в оболечке "shell":
   "type": "shell",
   "inline": []
```
```
2) Выполнение скрипта в инстансе:
   "type": "shell",
   "script": "file.sh",
   "execute_command": "sudo {{.Path}}"
```
```
3) Копирвоание файла в инстанс:
   "type": "file",
   "source": "files/puma.service",
   "destination": "/tmp/puma.service"
```
В связи с обнаружением ошибки связанной с программой `dpkg`, которая пытается запустить пакетный менеджер `apt-get` до того как оный закончит предыдущую задачу, приходится инициировать паузу между командами или использовать более сложное (но прекрасное) решение:
```
1) sleep 10 - пауза до перехода к следующей команде bash/shell.
```
```
2) Проверка занятости пакетного менеджера apt-get и выполнение по высвобождению:
"provisioners": [
        {
            "type": "shell",
            "inline": [
                "echo Waiting for apt-get to finish...",
                "a=1; while [ -n \"$(pgrep apt-get)\" ]; do echo $a; sleep 1s; a=$(expr $a + 1); done",
                "echo Done."
            ]
        },
```
Так же наблюдалась ошибка при работе пакетного менеджера `apt-get` запускаемого из скрипта с ключом `-y`:
```
debconf: unable to initialize frontend: Dialog
debconf: (Dialog frontend will not work on a dumb terminal, an emacs shell buffer, or without a controlling terminal.)
debconf: falling back to frontend: Readline
yandex: debconf: unable to initialize frontend: Readline
```
Решение ошибки записи ответа диалоговых окон в буфер в не интерактивной среде - принудительный вызов команды:
```
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
```
6. Проверка и запуск создания образа на основе шаблона `packer`:
```
packer validate ubuntu16.json
```
```
packer build ubuntu16.json
```
7. Создано исключение файла `variables.json` для `git` в файле `./.gitignore`.
## Дополнительное задание:
1. Создан шаблон `packer` `immutable.json`, который используется для создания `bake-образа`.
2. Создан скрипт `create-reddit-vm.sh`, который создаем VM на основе ранее созданного `bake-образа`.
