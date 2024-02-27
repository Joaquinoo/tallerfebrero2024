#!/usr/bin/env bash

ssh-keygen

echo -n "Ingrese el nombre de usuario del administrador de los servidores de destino: "
read user

echo -e "---------------------------------------------------------------------------------------"
echo -e "**Copiado de clave pública a servidores de destino utilizando $user**"
echo -e ""
echo -n "Ingrese la IP de uno de los servidores de destino (ingrese 0 para continuar el setup): "
read ip

while [ "$ip" != "0" ]
do
  ssh-copy-id $user@$ip
  echo -n "Ingrese la IP del servidor de destino (ingrese 0 para continuar el setup): "
  read ip
done

echo -e "---------------------------------------------------------------------------------------"
echo -e "**Instalando colecciones necesarias**"
ansible-galaxy install -r requirements.yml

echo -e "---------------------------------------------------------------------------------------"
echo -e "**Ejecutando initial.yml como sysadmin para configuración inicial de los servidores remotos**"
ansible-playbook -i inventories/hosts playbooks/initial.yml --ask-become-pass
