red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color

if [ "$1" = "--h" ] || [ "$1" = "--help" ]; then
	echo -e "For use correctly this script you should run:"
	echo -e "$0 [-u|--username username] [-p|--password password] [-h|--host host] [-f|--file file]"
	echo -e "********** Parameters *************"
	echo -e "-u|--username		Username with acces to database"
	echo -e "-p|--pasword		Password of the user"
	echo -e "-h|--host		Host where is the database"
	echo -e "-f|--file		File where find all data you want restore"
	echo -e "			The file should have this format:"
	echo -e "				(database)-[date][.sql.bz2]"
	echo -e "--h|--help		Print this message"
elif [ "$#" = 8 ]; then
	echo "The number of parameters are correct"

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
		echo -e "${red}Error: param username not found: [-u|--username username]${NC}"
		error=1
	fi
	if [ -z "$password" ]; then
		echo -e "${red}Error: param password not found: [-p|--password password]${NC}"
		error=1
	fi
	if [ -z "$host" ]; then
		echo -e "${red}Error: param host not found: [-h|--host host]${NC}"
		error=1
	fi
	database=$(echo ${file} | cut -d'-' -f1)
	regex="^$database-.*\.bz2"
	if ! echo "$file" | grep -q "$regex"; then
		echo -e "${red}Error: format of file incorrect: (database)-[date][.sql.bz2]${NC}"
		error=1
	fi
	if [ ! -r "$file" ]; then
		echo -e "${red}Error: file \"$file\" not found${NC}"
		error=1
	fi

	if [ -z "$error" ]; then
		echo "Running restore the database $database"
		echo -e "Command: ${green}bzip2 -dc $file | mysql --protocol=tcp --host=$host --user=$username --password=$password $database${NC}"
		bzip2 -dc $file | mysql --protocol=tcp --host=$host --user=$username --password=$password $database

		if [ $? -eq 0 ]; then
			echo "Restoring of data completed"
		else
			echo -e "${red}Error: exited with $?${NC}"
		fi
		exit $?
	fi
	
else
	echo -e "${red}Error: wrong number of parameters ($# of 8): $0 [-u|--username username] [-p|--password password] [-h|--host host] [-f|--file file]${NC}"
	echo "$0 --h for print help"
fi