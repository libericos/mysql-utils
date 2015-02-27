if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--h" ] || [ "$1" = "--help" ]; then
	echo "For use correctly this script you should run:"
	echo "$0 username password host database"
	echo "The file that it generated have this format: (database)-[date][.sql.bz2]"
elif [ "$#" = 4 ]; then
	echo "Number of parameters correct"
	username=$1
	password=$2
	host=$3
	database=$4
	
	now=$(date "+%Y-%m-%d:%H:%M:%S")
	echo "$now"

	file="$database-$now.sql.bz2"

	echo "mysqldump --opt --protocol=tcp --host=$host --user=$username --password=$password $database | bzip2 > $file"
	mysqldump --opt --protocol=tcp --host=$host --user=$username --password=$password $database | bzip2 > $file

	echo "File created: $file"
	ls -l $file
else
	echo "Error: wrong number of parameters: $0 username password host database"
	echo "$0 -h for print help"
fi