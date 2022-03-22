#!/bin/bash
#
# Script permettant de renommer correctement une BDD
# il tient compte de l'utilisateur s'il y en a un !
#
LC_ALL=fr_FR.UTF-8
set -e   # Exit immediately if a command exits with a non-zero status.

function help()
{
    printf "Usage: %s: [-uValue] [-pValue] CURRENT_NAME NEW_NAME\n" $self
    echo "Rename the MySQL database CURRENT_NAME to NEW_NAME"
    exit 1
}

function abort
{
    error=$?
    echo 'Process aborted !'
    exit $error
}

# Si je ne suis pas root ... tant pis pour moi ...
if [ "`id -u`" -ne 0 ]; then
	echo "$0 : Pas root ... Alors biloute ?"
	exit 1;
fi

USER=''
PASS=''
self=$(basename $0)

while getopts u:p:h option
do
    case $option in
        u)
            USER=" -u${OPTARG}"
            ;;
        p)
            PASS="${OPTARG}"
            ;;
        h)
            help
            ;;
        *)
            echo -e "Try ${self} -h"
            exit 1
            ;;
    esac
done

shift $(($OPTIND-1)) # On passe aux arguments

# Il faut exactement deux arguments, les noms des tables !
[ $# -ne 2 ] && help
olddb=$1
newdb=$2

# La connexion à la base de données
mysqlconn="mysql -p${PASS}${USER}"

# Vérification de la connexion et de la BDD à renommer
$mysqlconn $olddb -e exit > /dev/null
[ $? -ne 0 ] && echo "$olddb don't exist or authentication problem, please verify!" && exit 1

# Vérification du nom de la nouvelle BDD
db_exists=`$mysqlconn -h localhost -e "SHOW DATABASES LIKE '$newdb';" -sss`
if [ -n "$db_exists" ]; then
    echo "ERROR: New database already exists $newdb"
    # exit 1
fi

# Création de la nouvelle base de données
$mysqlconn -e "CREATE DATABASE $newdb;" > /dev/null
[ $? -eq 0 ] && echo "$newdb created ..."

# L'utilisateur de la base de données s'il y en a un doit être le même
$mysqlconn -e "use mysql; SELECT * FROM db WHERE Db = '$olddb';" > /dev/null
[ $? -eq 0 ] && echo "The User and Password are the same as for the old database : $olddb ..." && $mysqlconn -e "use mysql; UPDATE db SET Db = '$newdb' WHERE db.Db = '$olddb';";

# Les tables à faire migrer
params=$($mysqlconn -N -e "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE table_schema='$olddb';")
### echo $params;
for name in $params; do
      $mysqlconn -e "RENAME TABLE $olddb.$name to $newdb.$name"
      ## echo "$mysqlconn -e \"RENAME TABLE $olddb.$name to $newdb.$name\"";
done;

echo "Suppress old table $olddb ... and FLUSH PRIVILEGES;"
$mysqlconn -e "DROP DATABASE $olddb"
$mysqlconn -e "FLUSH PRIVILEGES;"
