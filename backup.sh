if [ "$1" = "--h" ] || [ "$1" = "--help" ]; then
	echo "For use correctly this script you should run:"
	echo "$0 [-u|--username username] [-p|--password password] [-h|--host host] [-d|--database database] [-f|--file file]"
	echo "********** Parameters *************"
	echo "-u|--username		Username with acces to database"
	echo "-p|--pasword		Password of the user"
	echo "-h|--host		Host where is the database"
	echo "-d|--database		Name of database you want make the backup"
	echo "-f|--file		OPTIONAL: file where you want save the backup"
	echo "			The file that it auto-generated have this format:"
	echo "				(database)-[date][.sql.bz2]"
	echo "--h|--help		Print this message"
elif [ "$#" = 8 ] || [ "$#" = 10 ]; then
	echo "The number of parameters are correct"
	now=$(date "+%Y-%m-%d:%H:%M:%S")

	while [[ $# > 1 ]]; do
		param="$1"
		case $param in
			-u|--username)
			username="$2"
			shift
			;;
			-p|--password)
			password="$2"
			shift
			;;
			-h|--host)
			host="$2"
			shift
			;;
			-d|--database)
			database="$2"
			if [ -z "$file"]; then
				file="$database-$now.sql.bz2"
			fi
			shift
			;;
			-f|--file)
			file="$2"
			shift
			;;
			*)
			#Uknown command
			;;
		esac
		shift
	done

	if [ -z "$username" ]; then
		echo "Error: param username not found: [-u|--username username]"
		error=1
	fi
	if [ -z "$password" ]; then
		echo "Error: param password not found: [-p|--password password]"
		error=1
	fi
	if [ -z "$host" ]; then
		echo "Error: param host not found: [-h|--host host]"
		error=1
	fi
	if [ -z "$database" ]; then
		echo "Error: param database not found: [-d|--database database]"
		error=1
	fi
	aux="$(echo ${file} | cut -d'-' -f1)"
	if [ -z "$aux" ] || [ "$aux" != "$database" ]; then
		echo "Error: format of file incorrect: (database)-[date][.sql.bz2]"
		error=1
	fi

	if [ -z "$error" ]; then
		echo "Running backup for $database"
		echo "Command: mysqldump --opt --protocol=tcp --host=$host --user=$username --password=$password $database | bzip2 > $file"
		mysqldump --opt --protocol=tcp --host=$host --user=$username --password=$password $database | bzip2 > $file

		echo "File created: $file"
		ls -l $file
	fi
	
else
	echo "Error: wrong number of parameters ($# of 8 or 10): $0 [-u|--username username] [-p|--password password] [-h|--host host] [-d|database database] [-f|--file file]"
	echo "$0 -h for print help"
fi