# Funcionamiento Playbooks - Taller de servidores Linux - Febrero 2024.

## Descripción:

- La finalidad de este documento es explicar el funcionamiento de los playbooks creados y la manera de utilizarlos.

## Prerequisitos:

- Ansible debe estar instalado en el nodo de control, que será el host donde se correra Ansible.
- Para instalar Ansible, el nodo de control debe contar con Python 2 (version 2.7) o Python 3 (versiones 3.5 y mas nuevas).
- Para poder ejecutar los playbooks los playbooks será necesario tener instalados las collections community.general y ansible.posix. Para instalarlas, utiliza el siguiente comando: 
    - ansible-galaxy install -r requirements.yml

## Playbooks:

- update_servers.yml:

    - Este playbook se encarga de actualizar los servidores Linux que fueron creados para el obligatorio (serverA y serverB) independientemente de su distribución. Para lograr esto, utilizamos los modulos "ansible. builtin.apt" y "ansible.builtin.yum" de Ansible que vienen incluidos con ansible-core. Una vez las tareas de update son completadas, el playbook se encarga de reiniciar los servidores utilizando "ansible.builtin.systemd".
    - El uso de este playbook es indispensable ya que necesitaremos tener los servidores actualizados para poder continuar.

- appserver_ubuntu.yml:

    - Este playbook se encarga de varias tareas en serverB (Ubuntu) con la finalidad de crear una aplicacion web. Dentro de estas tareas se encuentran: 
       - Instalar OpenJDK 8 
       - Instalar UFW para poder controlar el firewall, 
       - Descargar e instalar Tomcat 
       - Configurar el firewall para permitir trafico en los puertos 22 y 8080 
       - Copia el archivo sample.war del bastion al destino.

       1) Se encarga de instalar OpenJDK 8, lo cual es necesario para nuestra aplicacion web utilizando "ansible.builtin.apt".
       2) Usando el mismo modulo instala UFW.
       3) Utilizando el modulo "community.general.ufw" configura el firewall para permitir trafico en los puertos 22, 8080 y habilitamos el firewall.
       4) Crea el grupo "tomcat" utilizando "ansible.builtin.group"
       5) Crea el user "tomcat" utilizando "ansible.builtin.user".
       6) Utilizando "ansible.builtin.group" crea el directorio "tomcat", el cual esta definido en la variable "tomcat_dir".
       7) Descarga tomcat usando "ansible.builtin.unarchive". El repositorio elegido para la descarga esta definido en la variable "tomcat_url".  
       8) Copia el tomcat del directorio en el que fue descargado al directorio definido en tomcat_dir usando "ansible.builtin.copy". Tambien setea el owner y el group del directorio a "tomcat", y setea los permisos del directorio y archivos a 0755.
       9) Borra el directorio de descarga que fue creado en el punto 7) utilizando "ansible.builtin.file".
       10) Usando "ansible.builtin.copy" copia el archivo "sample.war" del directorio "./files/" al directorio destino, que en este caso es "/opt/tomcat/webapps/". A parte de esto, tambien setea el owner y grupo del directorio a "tomcat", y setea permisos a 0755.
       11) Utilizando el mismo modulo, copia el archivo de servicio de Tomcat del directorio "./files/tomcat.service" al destino "/etc/systemd/system/tomcat.service" y setea permisos a 0755.
       12) Realiza un "reload" de systemd utilizando el modulo "ansible.builtin.systemd".
       13) Por ultimo, habilita el servicio tomcat y lo inicia utilizando "ansible.builtin.systemd".
     
- proxy_rocky.yml (WIP):

    - Este playbook se encarga de varias tareas en serverA (Rocky) con la finalidad de configurar un proxy reverso. 
       1) Instala xxx utilizando el modulo "ansible.builtin.yum".
       2) Habilita el servicio xxx utilizando el modulo "ansible.builtin.service".
       3) Habilita el trafico en los puertos 80, 443 y 8080. Lo setea como permanente y lo habilita de manera inmediata.
       4) Copia el archivo de configuracion del proxy (sample-app.conf) del directorio ./files/ al directorio /etc/httpd/, lo renombra como "conf.d" y le setea permisos 0755.
       5) Por ultimo reinicia el servicio httpd.service utilizando el modulo "ansible.builtin.systemd".

       
## Uso:

- Los playbooks mencionados en este documento son ejecutados con el siguiente comando:
    - "ansible-playbook -i inventories/hosts [playbook_name]"
    - Recuerda reemplazar [playbook_name] por el nombre del playbook que deseas ejecutar.
- Los playbooks estan diseñados para utilizar los host que estan definidos dentro del archivo "hosts.yml" que se encuentra en el directorio "/inventories/". 
    - En caso de necesitar cambiar los hosts, o agregar adicionales, es posible editar dicho archivo y agregarlos. 
- Nota adicionales:
    - Para checkear sintaxis de un playbook se puede agregar la opcion "--syntax-check" al comando de ejecucion.
    - Para hacer un "dry run" del playbook se puede usar la opcion "--check".
    - Es posible agregar hosts, quitarlos o modificar los utilizados actualmente. Para esto sera necesario modificar el archivo "hosts" y/o los playbooks.
    - En caso de que el playbook utilize variables, estas estaran definidas al comienzo del archivo del playbook. En caso de ser necesario, las variables pueden ser editadas a gusto.
    - Al haber utilizado "become: true", en caso de que el usuario tenga permisos de sudo CON contraseña, se debera utilizar la opcion "--ask-become-pass" en el comando a la hora de ejecutar el playbook. De lo contrario, en caso de que el usuario tenga permisos de sudo SIN contraseña, el comando no requerira esta opcion.   

## Créditos

Joaquin Laguzzi & Emilio Pastro.
