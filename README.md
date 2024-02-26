# Funcionamiento Playbooks - Taller de servidores Linux - Febrero 2024.

## Descripción:
La finalidad de este documento es explicar el funcionamiento de los
playbooks creados y la manera de utilizarlos.


## Playbooks:
- initial.yml:
  - Este playbook se encarga de copiar la clave SSH publica del usuario 
    "ansible" a los distintos servidores Linux creados para el
    obligatorio (serverA y serverB) independientemente de su
    distribución.
    Para hacer esto, utiliza el modulo "ansible.posix.authorized_key".
    Tambien se encarga de deshabilitar el login de root por SSH seteando
    "PermitRootLogin" a "no" y deshabilita el login con password
    seteando "PasswordAuthentication" a "no" utilizando el modulo 
    "ansible.posix.authorized_key".
    Por ultimo, se encarga de reiniciar el servicio SSH utilizando
    "ansible.builtin.systemd" para que los cambios realizados sean
    tomados.
  - El uso de este playbook es indispensable para luego poder ejecutar
    tareas con Ansible en los servidores mencionados y no necesitar
    escribir la contraseña del usuario cada vez ya que no sera
    requesteada.

- update_servers.yml:
  - Este playbook se encarga de actualizar los servidores Linux que
    fueron creados para el obligatorio (serverA y serverB)
    independientemente de su distribución. Para lograr esto, utilizamos 
    los modulos "ansible.builtin.apt" y "ansible.builtin.yum" de Ansible
    que vienen incluidos con ansible-core.
    Una vez las tareas de update son completadas, el playbook se encarga
    de reiniciar los servidores utilizando "ansible.builtin.systemd".
  - El uso de este playbook es indispensable ya que necesitaremos tener
    los servidores actualizados para poder continuar.

- appserver_ubuntu.yml:
  - Este playbook se encarga de varias tareas en serverB (Ubuntu) con
    la finalidad de crear una aplicacion web. 
    1) Se encarga de instalar OpenJDK 8, lo cual es necesario para
       nuestra aplicacion web utilizando "ansible.builtin.apt".
    2) Usando el mismo modulo instala UFW.
    3) Utilizando el modulo "community.general.ufw" configura el
       firewall para permitir trafico en los puertos 22, 8080 y 
       habilitamos el firewall.
    4) Crea el grupo "tomcat" utilizando "ansible.builtin.group"
    5) Crea el user "tomcat" utilizando "ansible.builtin.user".
    6) Utilizando "ansible.builtin.group" crea el directorio "tomcat", 
       el cual esta definido en la variable "tomcat_dir".
    7) Descarga tomcat usando "ansible.builtin.unarchive". El
       repositorio elegido para la descarga esta definido en la variable
       "tomcat_url".  
    8) Copia el tomcat del directorio en el que fue descargado al 
       directorio definido en tomcat_dir usando "ansible.builtin.copy". 
       Tambien setea el owner y el group del directorio a "tomcat",
       y setea los permisos del directorio y archivos a 0755.
    9) Borra el directorio de descarga que fue creado en el punto 7)
       utilizando "ansible.builtin.file".
   10) Usando "ansible.builtin.copy" copia el archivo "sample.war"
       del directorio "./files/" al directorio destino, que en este 
       caso es "/opt/tomcat/webapps/". A parte de esto, tambien setea
       el owner y grupo del directorio a "tomcat", y setea permisos a
       0755.
   11) Utilizando el mismo modulo, copia el archivo de servicio de 
       Tomcat del directorio "./files/tomcat.service" al destino 
       "/etc/systemd/system/tomcat.service" y setea permisos a 0755.
   12) Realiza un "reload" de systemd utilizando el modulo 
       "ansible.builtin.systemd".
   13) Por ultimo, habilita el servicio tomcat y lo inicia utilizando
       "ansible.builtin.systemd".
  - Nota: Las variables mencionadas a lo largo del proceso estan 
           definidas al comienzo del archivo "appserver_ubuntu.yml".
     
- proxy_rocky.yml (WIP):
  - Este playbook se encarga de varias tareas en serverA (Rocky) con la
    finalidad de configurar un proxy reverso. 
    1) Instala xxx utilizando el modulo "ansible.builtin.yum".
    2) Habilita el servicio xxx utilizando el modulo 
       "ansible.builtin.service".
    3) Habilita el trafico en los puertos 80, 443 y 8080. Lo setea como
       permanente y lo habilita de manera inmediata.
    4) Copia el archivo de configuracion del proxy (sample-app.conf) 
       del directorio ./files/ al directorio /etc/httpd/, lo renombra
       como "conf.d" y le setea permisos 0755.
    5) Por ultimo reinicia el servicio httpd.service utilizando el 
       moduli "ansible.builtin.systemd".

       
## Uso:
- Los playbooks mencionados en este documento son ejecutados con el
  siguiente comando:
    - "ansible-playbook -i inventories/hosts [playbook_name]"
- Los playbooks estan diseñados para utilizar los host que estan
  definidos dentro del archivo "hosts" que se encuentra en el
  directorio "/tallerfebrero2024/inventories/".
- Nota adicionales:
    - Recuerda reemplazar [playbook_name] por el nombre del playbook 
      que deseas ejecutar.
    - Para checkear sintaxis se puede usar la opcion "--syntax-check".
    - Para hacer un "test run" se puede usar la opcion "--check".
    - Es posible agregar hosts, quitarlos o modificar los utilizados
      actualmente. Para esto sera necesario modificar el archivo "hosts"
      y/o los playbooks.


## Créditos
Joaquin Laguzzi & Emilio Pastro.
