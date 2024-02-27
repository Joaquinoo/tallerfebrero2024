# README - Taller de servidores Linux - Febrero 2024.

## Descripción:

Abordaremos cómo configurar el entorno inicial para la ejecución de los playbooks, además de explicar el funcionamiento y la estructura general del proyecto.

## Prerrequisitos:
Lo único necesario además de ansible instalado en el equipo bastión, es ejecutar el script "setup.sh" y seguir los prompts:
```
./setup.sh
```
Este script crea el public-private keypair, copia la clave pública a los servidores y al usuario definidos en los inputs que se solicitan, ejecuta ```initial.yml``` para realizar la configuración inicial en los servidores e instala los requisitos definidos en ```requirements.yml```.

## Estructura fundamental del repo:
### ```/```
- ```main_playbook.yml```
    - Contiene la llamada a todos los playbooks en orden.
    - Si se desea tener mayor control sobre la ejecución de las tareas, es posible ejecutar manualmente los playbooks contenidos en ```playbooks/```.

- ```requirements.yml```
    - Contiene todas las colecciones necesarias para el uso de los playbooks.

- ```setup.sh```
    - Script inicial que facilita la configuración inicial del entorno Ansible.
### ```playbooks/```
- ```playbooks/update_servers.yml```
    - Este playbook se encarga de actualizar los servidores Linux que fueron creados para el proyecto (Rocky como Proxy y Ubuntu como Web Server).
    - El uso de este playbook es indispensable si es que necesitamos mantener nuestros servidores al día en cuanto a actualizaciones generales.

- ```playbooks/appserver_ubuntu.yml```

    - Este playbook se encarga de varias tareas en el Web Server (Ubuntu) con la finalidad de hostear una aplicación web de prueba. Dentro de estas tareas se encuentran: 
       - Instalación de ```OpenJDK 8```.
       - Instalación de ```ufw``` para poder controlar el firewall.
       - Descarga, instalación y configuración de ```Tomcat 8.5``` como servicio.
       - Configuración de firewall para ```permitir``` tráfico entrante proveniente del bastión en el ```puerto 22```.
       - Configuración de firewall para ```permitir``` tráfico entrante proveniente del proxy en el ```puerto 8080```.
       - Copiado del archivo ```sample.war``` (aplicación de prueba) hacia el servidor de destino.
     
- ```playbooks/proxy_rocky.yml```

    - Este playbook se encarga de realizar las tareas necesarias para que el Proxy Reverso (Rocky) sea configurado de manera exitosa. Dentro de estas tareas se encuentran:
      - Instalación y configuración de ```apache httpd```.
      - Configuración de firewall para ```permitir``` todo el tráfico entrante en los puertos TCP: ```80, 8080 y 443```
      - Configuración de ```SELinux``` para permitir que apache actúe como relay y para que pueda conectarse a la red.
      - Copiado del archivo ```sample-app.conf``` (config file del proxy reverso).
- ```playbooks/initial.yml```
    - Contiene la configuración inicial de los servidores remotos, así como del servicio SSH.

### ```files/```

- ```files/sample_app.conf```
    - Contiene toda la configuración del proxy reverso.
    - Importante editarlo en caso de que las IPs de los servidores cambien.
- ```files/tomcat.service```
    - Contiene la configuración del servicio de Tomcat 8.5.
    - Es buena idea revisar su contenido para verificar que se adapta a nuestras necesidades.
- ```files/sample.war```
    - Aplicación de prueba.
### ```inventories/```
- ```inventories/hosts```
    - Contiene los hosts sobre los que deseamos correr los playbooks.


## Uso:

Una vez comprendida la estructura fundamental del repo, es posible ejecutar el playbook inicial.

En la raíz del repo:
```
ansible-playbook -i inventories/hosts main_playbook.yml
```
### Nota adicionales:
    - Para chequear sintaxis de un playbook se puede agregar la opcion "--syntax-check" al comando de ejecución.
    - Para hacer un "dry run" del playbook se puede usar la opcion "--check".
    - Es posible agregar hosts, quitarlos o modificar los utilizados actualmente. Para esto sera necesario modificar el archivo "hosts" y/o los playbooks.
    - En caso de que el playbook utilice variables, estas estaran definidas al comienzo del archivo del playbook. En caso de ser necesario, las variables pueden ser editadas a gusto.
    - Al haber utilizado "become: true", en caso de que el usuario tenga permisos de sudo CON contraseña, se debera utilizar la opcion "--ask-become-pass" en el comando a la hora de ejecutar el playbook. De lo contrario, en caso de que el usuario tenga permisos de sudo SIN contraseña, el comando no requerira esta opcion.   

## Créditos

Hecho con 💞 por:
- Joaquin Laguzzi
- Emilio Pastro.
