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

declare -A ATHLETES_INFO_ARRAY
declare -A LOWEST_ID_BY_NATIONALITY

while IFS="," read -r id nationality height weight; do
	if [[ ! -z $height && ! -z $weight && ! -z $nationality ]]; then
		if [[ $(echo "$height>0 && $height<=$MAX_HEIGHT" | bc) -eq 1 &&  $(echo "$weight>0 && $weight<=$MAX_WEIGHT" | bc) -eq 1 ]]; then
           ((ATHLETES_INFO_ARRAY[$nationality]++))

           if [[ ! ${LOWEST_ID_BY_NATIONALITY[$nationality]} ]]; then
                LOWEST_ID_BY_NATIONALITY[$nationality]=$id
           elif [[ $id -lt ${LOWEST_ID_BY_NATIONALITY[$nationality]} ]]; then
                LOWEST_ID_BY_NATIONALITY[$nationality]=$id
           fi
		fi
	fi
done < <(cut -d "," -f1,3,6,7 $FILE| tail -n+2)

for KEY in "${!ATHLETES_INFO_ARRAY[@]}"; do
  echo "Key: $KEY  Value: ${ATHLETES_INFO_ARRAY[$KEY]}"
done

echo "--------------------------------------------------"

for KEY in "${!LOWEST_ID_BY_NATIONALITY[@]}"; do
  echo "Key: $KEY  Value: ${LOWEST_ID_BY_NATIONALITY[$KEY]}"
done
