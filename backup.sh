red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color

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
		echo -e "${red}Error: parameter username not found: [-u|--username username]${NC}"
		error=1
	fi
	if [ -z "$password" ]; then
		echo -e "${red}Error: parameter password not found: [-p|--password password]${NC}"
		error=1
	fi
	if [ -z "$host" ]; then
		echo -e "${red}Error: parameter host not found: [-h|--host host]${NC}"
		error=1
	fi
	if [ -z "$database" ]; then
		echo -e "${red}Error: parameter database not found: [-d|--database database]${NC}"
		error=1
	fi
	aux="$(echo ${file} | cut -d'-' -f1)"
	if [ -z "$aux" ] || [ "$aux" != "$database" ]; then
		echo -e "${red}Error: format of file incorrect: (database)-[date][.sql.bz2]${NC}"
		error=1
	fi

	if [ -z "$error" ]; then
		echo "Running backup for $database"
		echo -e "Command: ${green}mysqldump --opt --protocol=tcp --host=$host --user=$username --password=$password $database | bzip2 > $file${NC}"
		mysqldump --opt --protocol=tcp --host=$host --user=$username --password=$password $database | bzip2 > $file

		echo "File created: $file"
		ls -l $file
	fi
	
else
	echo -e "${red}Error: wrong number of parameters ($# of 8 or 10): $0 [-u|--username username] [-p|--password password] [-h|--host host] [-d|--database database] [-f|--file file]${NC}"
	echo "$0 --h for print help"
fi