#!/bin/sh

if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--h" ] || [ "$1" = "--help" ]; then
	echo "Para usar el script se necesitan especificar los siguientes parametros"
	echo "$0 -b username password host database"
	echo "$0 -r username password host file"
	echo "-b : Realiza el backup en un archivo autogenerado"
	echo "-r : Restura una base de datos a partir de un archivo"
elif [ "$#" = 5 ] && [ "$1" = "-b" ]; then
	echo "Numero de parametros correcto"
	username=$2
	password=$3
	host=$4
	database=$5
	#Segundo desde 1970 0:00:00 UTC
	now=$(date "+%Y-%m-%d:%H:%M:%S")
	echo "$now"

	file="$database-$now.backup.sql"

	echo "mysqldump --opt --protocol=tcp --host=$host --user=$username --password=$password $database > $file"
	mysqldump --opt --protocol=tcp --host=$host --user=$username --password=$password $database > $file

	echo "Archivo de backup creado: $file"
	ls -l $file
elif [ "$#" = 5 ] && [ "$1" = "-r" ]; then
	echo "Numero de parametros correcto"
	username=$2
	password=$3
	host=$4
	file=$5
	database=$(echo ${file} | cut -d'-' -f1)

	echo "mysql --protocol=tcp --host=$host --user=$username --password=$password $database < $file"
	mysql --protocol=tcp --host=$host --user=$username --password=$password $database < $file

	echo "Restauracion de la base de datos completada"
else
	echo "Error: faltan parametros: $0 [-b|-r] username password host [database|file]"
	echo "$0 -h para mostrar ayuda"
fi