if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--h" ] || [ "$1" = "--help" ]; then
	echo "For use correctly this script you should run:"
	echo "$0 username password host file"
	echo "The file should have this format: (database)-[date][.sql.bz2]"
elif [ "$#" = 4 ]; then
	echo "Number of parameters correct"
	username=$1
	password=$2
	host=$3
	file=$4
	database=$(echo ${file} | cut -d'-' -f1)

	echo "bzip2 -dc $file | mysql --protocol=tcp --host=$host --user=$username --password=$password $database"
	bzip2 -dc $file | mysql --protocol=tcp --host=$host --user=$username --password=$password $database

	echo "Restoring of data completed"
else
	echo "Error: wrong number of parameters: $0 username password host file"
	echo "$0 -h for print help"
fi