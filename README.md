# mysql-utils
MySQL management utils

## Managing backups of MySQL
### Backup
This script makes a backup of a database for a specific host.  
To run the script should put the arguments in the correct order:
```
backup.sh [-u|--username username] [-p|--password password] [-h|--host host] [-d|--database database] [-f|--file file]
```
- -u|--username: Username with acces to database"
- -p|--pasword: Password of the user"
- -h|--host: Host where is the database"
- -d|--database: Name of database you want make the backup"
- -f|--file: OPTIONAL: file where you want save the backup"
- >The file that it auto-generated have this format:"
- >```(database)-[date][.sql.bz2]"```

##### [Download](backup.sh)

### Restore
This script restore the database from a file in your system.  
Only works if the file is compresed with Bzip2 and have this format:  
`[database]-[date].sql.bz2`  
To run the script should put the arguments in the correct order:
```
restore.sh [username] [password] [host] [file/to/restore]
```
- username: the name of the user of database
- password: the password of the user of database
- host: the IP or URL where is the database
- file: the file where find all data you want restore  

##### [Download](restore.sh)