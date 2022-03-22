#!/bin/bash
LC_ALL=fr_FR.UTF-8

#
# Menu general verifiant les arguments ...
#

source $(pwd)/functions.sh
if [ "`id -u`" -ne 0 ]; then
	echo_red "$0 : Pas root ... T'es un biloute ?"
	exit 1;
fi

source $(pwd)/admin_mysqluser.sh

if [ ! -f infos.txt ]; then
	echo_magenta "$0 : Donnez l'adresse E-MAIL de l'administrateur 'no verification !!!' "
	read EMAILADM
	echo EMAILADM="$EMAILADM" >> infos.txt
fi
echo 

source $(pwd)/infos.txt

echo 

if oui_non "$0 : Voulez-vous creer un compte mysql oui/non ? " ; then
	genepass
	mysql_new_user
fi

# if oui_non "$0 : Voulez-vous modifier le password root de mysql oui/non ? " ; then
# 	genepass
# 	mysqluser
# fi

if oui_non "$0 : Voulez-vous creer un équivalent root pour mysql oui/non ? " ; then
	# Une fonction ?
mysql_equivroot () {
	echo -n "$0: - Donner le login (compte équivalent root) : "
    read X_LOGINBDD_X
	echo -n "$0: - Donner le mot de passe (compte équivalent root) : "
    read X_PASSWD_X
	echo -n "$0: - Donner le mot de passe root : "
	read X_ROOTPASSWD_X
		
	$MYSQL -u root -p${X_ROOTPASSWD_X} -e "use mysql; CREATE USER '${X_LOGINBDD_X}'@'%' IDENTIFIED BY '${X_PASSWD_X}'; GRANT ALL PRIVILEGES ON *.* TO '${X_LOGINBDD_X}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
	
	if [ $? -eq 0 ]; then
		echo "$0: Création du compte équivalent root :"
		echo -e "$0: Login : ${X_LOGINBDD_X}\n Password : ${X_PASSWD_X}"
    else
        echo "========= La création d'un compte a équivalent root échoué ========="
    fi
}


fi

if oui_non "$0 : Voulez-vous modifier un compte mysql oui/non ? " ; then
if oui_non "$0 : Voulez-vous modifier le LOGIN d'un compte mysql oui/non ? " ; then
		echo "Modification du LOGIN !"
		# Une fonction ?
mysql_modif_login () {
	echo -n "$0: - Donner le login du compte : "
    read X_OLDLOGINBDD_X
	echo -n "$0: - Donner le nouveau login du compte : "
	read X_NEWLOGINBDD_X
	echo -n "$0: - Donner le mot de passe de root : "
    read X_ROOTPASSWD_X
    
	echo "il manque a tester la modif de la table db !!! ";
		
	$MYSQL -u root -p${X_ROOTPASSWD_X} -e "use mysql; UPDATE user SET user='$X_NEWLOGINBDD_X' WHERE user='$X_OLDLOGINBDD_X'; UPDATE db SET User='$X_NEWLOGINBDD_X' WHERE db.User='$X_OLDLOGINBDD_X'; FLUSH PRIVILEGES;"
	
	if [ $? -eq 0 ]; then
		echo "$0: modification OK !"
    else
        echo "========= La modification du login a échoué ========="
    fi
}


	elif oui_non "$0 : Voulez-vous modifier le MOT DE PASSE d'un compte mysql oui/non ? " ; then
		echo -n "Modification du MOT DE PASSE, exemple : "
		genepass
		echo ''
		# Une fonction ?
mysql_modif_password () {
	echo -n "$0: - Donner le login du compte : "
    read X_LOGINBDD_X
	echo -n "$0: - Donner le mot nouveau mot de passe : "
	read X_NEWPASSWD_X
	echo -n "$0: - Donner le mot de passe de root : "
    read X_ROOTPASSWD_X
    
	$MYSQL -u root -p${X_ROOTPASSWD_X} -e "use mysql; UPDATE user SET Password=PASSWORD('$X_NEWPASSWD_X') WHERE user='$X_LOGINBDD_X'; FLUSH PRIVILEGES;"
	
	if [ $? -eq 0 ]; then
		echo "$0: modification OK !"
    else
        echo "========= La modification du mot de passe a échoué ========="
    fi
}

    elif oui_non "$0 : Voulez-vous modifier le NOM d'une BDD oui/non ? " ; then
        echo "Modification du NOM de la BDD"
        # Une fonction ?
mysql_modif_bddname() {
    echo -n "$0: - Donner le nom actuel (OLD) de la BDD : "
	read X_OLDDB_X
    echo -n "$0: - Donner le nouveau nom (NEW) de la BDD : "
	read X_NEWDB_X	
	echo -n "$0: - Mot de passe root BDD : "
	read X_PASS_X
	
	$(pwd)/mysql_rename_synthese.sh -uroot -p$X_PASS_X $X_OLDDB_X $X_NEWDB_X
	
	if [ $? -eq 0 ]; then
		echo "$0: Modification OK !"
    else
        echo "========= La modification du nom de la BDD a échoué ========="
    fi
}

	fi
fi

if oui_non "$0 : Voulez-vous supprimer une BDD mysql oui/non ? " ; then
	# Une fonction ?
mysql_delete_bdd () {
	echo -n "$0: - donner le nom de la BDD : "
	read X_DBNAME_X
	echo -n "$0: - Donner le mot de passe de root : "
    	read X_ROOTPASSWD_X
    
	echo "il manque a tester la modif de la table db !!! ";
		
	$MYSQL -u root -p${X_ROOTPASSWD_X} -e "use mysql; DROP DATABASE IF EXISTS ${X_DBNAME_X}; FLUSH PRIVILEGES;"
	
	if [ $? -eq 0 ]; then
		echo "$0: la BDD ${X_DBNAME_X} a bien été supprimée"
    	else
        	echo "========= La modification du login a échoué ========="
    	fi
}

fi

if oui_non "$0 : Voulez-vous supprimer un compte (LOGIN) d'une BDD mysql oui/non ? " ; then
	# Une fonction ?
mysql_delete_user () {
	echo -n "$0: - donner le username du compte : "
	read X_LOGIN_X
	echo -n "$0: - Donner le mot de passe de root : "
    	read X_ROOTPASSWD_X

    $MYSQL -u root -p${X_ROOTPASSWD_X} -e "use mysql; REVOKE ALL PRIVILEGES, GRANT OPTION FROM '${X_LOGIN_X}'@'localhost'; DROP USER IF EXISTS '${X_LOGIN_X}'@'localhost'; FLUSH PRIVILEGES;"
	
	if [ $? -eq 0 ]; then
		echo "$0: l'utilisateur (username ou login) ${X_DBNAME_X} a bien été supprimée"
    	else
        	echo "========= La modification du login a échoué ========="
    	fi

}

fi

