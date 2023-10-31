#!/bin/sh

folder_id=$(yc config list | grep folder-id | awk '{print $2}') # грепаем id-каталога

yc compute instance create \
  --name reddit-app \
  --zone=ru-central1-a \
  --hostname reddit-app \
  --core-fraction 50 \
  --create-boot-disk image-folder-id=${folder_id},image-family=reddit-full,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata-from-file user-data=metadata_1.yaml \
  --metadata serial-port-enable=1 \
