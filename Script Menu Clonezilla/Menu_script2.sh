#!/bin/bash

#ARCHIVOS ****************************************************

#Para que funcione requiere:


#sudo cp /tftpboot/nbi_img/pxelinux.cfg/default /tftpboot/nbi_img/pxelinux.cfg/default.back


#1_  crear la carpeta IMG  que es la que almacenara el listado de las imagenes. Por defecto estaen configurado para que funcione en escritorio.Crear carpeta IMGI sera donde almacene los textos para imagenes a capturar.
#2 Dar parmisos de edicion al archivo Default de clonezilla (/tftpboot/nbi_img/pxelinux.cfg/default)
#3 sudo cp /tftpboot/nbi_img/pxelinux.cfg/default /tftpboot/nbi_img/pxelinux.cfg/default.back
#
#4 Dar permisos de ejecucion a este script MENU.SH


#Este es el menu por defecto
MENU=/home/$(whoami)/Escritorio/default

#Aca el menu va agregando, este tendra la lista que se vera 
#Default 2 debe reemplazar a la carpeta /tftpboot/nbi_img/pxelinux.cfg/
#MN=/home/$(whoami)/Escritorio/default2
MN=/tftpboot/nbi_img/pxelinux.cfg/default
#Carpeta que contiene los comandos de las imagenes


##############################################################
#Carpeta que contiene los comandos de las imagenes

ESCRIBE(){
cat $MENU > $MN
clear
echo -e "\e[32m Escriba la imagen que desea agregar (no debe tener espacios ni caracteres especiales) \e[m "
read IMG

LBC=/home/$(whoami)/Escritorio/IMGS/$IMG

echo "label clonezilla " >> $LBC
echo  "MENU DEFAULT  "  >> $LBC
echo  "# MENU HIDE  "   >> $LBC
echo  "MENU LABEL  $IMG "    >> $LBC
echo  "# MENU PASSWD " >> $LBC
echo  "# Append DHCP/BOOTP to the kernel command line, i.e., ip=<client-ip>:<boot-server-ip>:<gw-ip>:<netmask> " >> $LBC
echo  "# We need this when using proxy DHCP ">> $LBC
echo  IPAPPEND 1 >> $LBC
echo  kernel vmlinuz-pxe >> $LBC
echo  append initrd=initrd-pxe.img devfs=nomount drblthincli=off selinux=0 quiet text 1 edd=on    ocs_opt="-l en_US.UTF-8  -g auto -e1 auto -e2 -r --clone-hidden-data -p reboot -scr restoredisk $IMG sda" >> $LBC

echo -e "\n" >> $LBC
echo -e "\n" >> $LBC

echo -e "\e[32m la imagen fue agregada \e[m "

}

ESCRIBEI(){
#Escribe default2 siempre partiendo de default
cat $MENU > $MN
clear
echo -e "\e[32m Escriba el nombre de la imagen que creara (no debe tener espacios ni caracteres especiales) \e[m "
read IMGI

echo label clonezilla >> $MN
echo MENU DEFAULT >> $MN
echo # MENU HIDE
echo MENU LABEL Clonar imagen $IMGI >> $MN
echo # MENU PASSWD >> $MN
echo # Append DHCP/BOOTP to the kernel command line, i.e., ip=<client-ip>:<boot-server-ip>:<gw-ip>:<netmask> >> $IC
echo   # We need this when using proxy DHCP >> $MN
echo   IPAPPEND 1 >> $MN
echo   kernel vmlinuz-pxe >> $MN
echo   append initrd=initrd-pxe.img devfs=nomount drblthincli=off selinux=0 quiet text 1 edd=on    ocs_opt="-l en_US.UTF-8  --use-partclone --clone-hidden-data -scs -p reboot -z1p -i 100000000 -scr savedisk $IMGI sda" >> $MN
echo   TEXT HELP >> $MN
echo   * Servidor de imagenes version: 2021 >> $MN
echo   * mcaballero >> $MN
echo   ENDTEXT >> $MN
}

################################################################


FORESCRIBE(){
for i in $(ls /home/$(whoami)/Escritorio/IMGS/ | sort )
do
cat /home/$(whoami)/Escritorio/IMGS/$i >> $MN
done
}


FORMUESTRA(){
clear
for i in $(ls /home/$(whoami)/Escritorio/IMGS/ | sort )
do
echo $i 
done

echo -e "\n" 
echo -e "\n" 
echo -e "\n" 

}

BORRA(){
echo -e "\e[31m Escriba la imagen que desea eliminar \e[m "
read IMGB 
rm /home/$(whoami)/Escritorio/IMGS/$IMGB
cat $MENU > $MN
FORESCRIBE

echo -e "\n" 
echo -e "\n" 
echo -e "\n" 
}

#Iniciando el scritp

#Escribe default2 siempre partiendo de default

cat $MENU > $MN
FORESCRIBE


INICIO(){
echo " ************************* "
echo "  BIENVENIDO $USER"
echo " *************************"
echo "       Menu principal      "
echo "Elige una de las opciones"

echo "1 Ver listado de imagenes"
echo "2 Agregar Imagen"
echo "3 Borrar Imagen"
echo "4 Capturar imagen"
echo "0 Salida"
read -n 1 OPCION
}

while [ 1 ]
clear
INICIO
do

case $OPCION in 
	0)exit ;;
	1)FORMUESTRA  ;;
	2)ESCRIBE && FORESCRIBE ;;
	3)FORMUESTRA
	  BORRA ;;
	4)ESCRIBEI;;
	*)echo "Elija una de las opciones" ;;
esac
echo "preciona una tecla para continuar"
read -n 1 line
done
clear
