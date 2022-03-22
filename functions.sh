#!/bin/bash

#
# Fonctions d'affichage + generation mot de passe + oui_non


BOOTUP=color
RES_COL=60
MOVE_TO_COL="echo -en \\033[300C\\033[$[${COLUMNS}-${RES_COL}]D"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_BLEU="echo -en \\033[1;34m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
LOGLEVEL=1

SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_RED="echo -en \\033[1;31m"
SETCOLOR_VERT="echo -en \\033[1;32m"
SETCOLOR_CYAN="echo -en \\033[1;36m"
SETCOLOR_MAGENTA="echo -en \\033[1;35m"

echo_success() {
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "[  "
  [ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS
  echo -n "OK"
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "  ]"
  return 0
}

echo_red () {
  $SETCOLOR_RED
  echo -ne "$1"
  $SETCOLOR_NORMAL
  echo ""
  return 0	
}

echo_bleu () {
  	$SETCOLOR_BLEU
  	echo -ne "$1"
  	$SETCOLOR_NORMAL
  	echo ""
  	return 0	
}

echo_vert () {
 	$SETCOLOR_VERT
  	echo -ne "$1"
  	$SETCOLOR_NORMAL
  	echo ""
  	return 0	
}

echo_cyan () {
 	$SETCOLOR_CYAN
  	echo -ne "$1"
  	$SETCOLOR_NORMAL
  	echo ""
  	return 0	
}

echo_magenta () {
	$SETCOLOR_MAGENTA
	echo -ne "$1"
	$SETCOLOR_NORMAL
	echo ""
	return 0
}

genepass () {
MATRICE="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
LONGUEUR="8"
# ==> Modification possible de 'LONGUEUR' pour des mots de passe plus longs.


while [ "${n:=1}" -le "$LONGUEUR" ]
# ==> Rappelez-vous que := est l'op�rateur de "substitution par d�faut".
# ==> Donc, si 'n' n'a pas �t� initialis�, l'initialisez � 1.
do
	PASS="$PASS${MATRICE:$(($RANDOM%${#MATRICE})):1}"
	# ==> Tr�s intelligent, pratiquement trop astucieux.

	# ==> Commen�ons par le plus int�gr�...
	# ==> ${#MATRICE} renvoie la longueur du tableau MATRICE.

	# ==> $RANDOM%${#MATRICE} renvoie un nombre al�atoire entre 1 et la
	# ==> longueur de MATRICE - 1.

	# ==> ${MATRICE:$(($RANDOM%${#MATRICE})):1}
	# ==> renvoie l'expansion de MATRICE � une position al�atoire, par
	# ==> longueur 1. 
	# ==> Voir la substitution de param�tres {var:pos:len}, section 3.3.1
	# ==> et les exemples suivants.

	# ==> PASS=... copie simplement ce r�sultat dans PASS (concat�nation).

	# ==> Pour mieux visualiser ceci, d�commentez la ligne suivante
	# ==>             echo "$PASS"
	# ==> pour voir la construction de PASS, un caract�re � la fois,
	# ==> � chaque it�ration de la boucle.

	let n+=1
	# ==> Incr�mentez 'n' pour le prochain tour.
done

echo "$PASS"      # ==> Ou, redirigez le fichier, comme voulu.
}

oui_non () {
# $1 Prompt
RET="A"

while [ "$RET" = "A" ] ; do
        echo -n "$1 "
        read
        if [ "$REPLY" = "" ] ; then REPLY="A" ; fi
        if [ "$REPLY" = "valide" ] || [ "$REPLY" = "oui" ] || [ "$REPLY" = "o" ] || [ "$REPLY" = "v" ] || [ "$REPLY" = "V" ]; then RET="0" ; fi
        if [ "$REPLY" = "modif" ] || [ "$REPLY" = "non" ] || [ "$REPLY" = "n" ] || [ "$REPLY" = "m" ] || [ "$REPLY" = "M" ] ; then RET="1" ; fi
done
return $RET
}


