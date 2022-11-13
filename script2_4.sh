#!/bin/bash

# Definim els arguments posicionals com a variables per a una millor legibilitat
FILE=$1
MAX_HEIGHT=$2
MAX_WEIGHT=$3

# Controlem que no falti cap paràmetre. En cas contrari que salti un error i finalitzi execució de l'script
if [[ -z $FILE ||-z $MAX_HEIGHT || -z $MAX_WEIGHT ]]; then
	echo "Error: mandatory argument is missing"
	exit 1
fi

# Controlem que el fitxer existeixi i que l'altura i pes màxim siguin naturals > 0. Sinó es mostrarà error i finalitzarà execució de l'script
if [[ ! -f $FILE || $(echo "$MAX_HEIGHT <= 0" | bc) -eq 1 || $(echo "$MAX_WEIGHT <= 0" | bc) -eq 1 ]]; then
	echo "Error: argument is not valid"
	exit 1
fi

declare -a athletes_info_array

while IFS="," read -r id nationality height weight; do
	if [[ ! -z $height && ! -z $weight ]]; then
		if [[ $(echo "$height>0 && $height<=$MAX_HEIGHT" | bc) -eq 1 &&  $(echo "$weight>0 && $weight<=$MAX_WEIGHT" | bc) -eq 1 ]]; then
		echo athletes_info_array[$nationality]= $nationality
		fi
	fi

done < <(cut -d "," -f1,3,6,7 $FILE| tail -n+2)
