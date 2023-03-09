#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT_ID="$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1" 2> /dev/null)"
if [[ -z $ELEMENT_ID ]]
then
  ELEMENT_ID="$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'" 2> /dev/null)"
  if [[ -z $ELEMENT_ID ]]
  then
    ELEMENT_ID="$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'" 2> /dev/null)"
    if [[ -z $ELEMENT_ID ]]
    then
      echo "I could not find that element in the database."
      exit
    fi
  fi
fi

QUERY="$($PSQL "SELECT elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types on properties.type_id = types.type_id WHERE elements.atomic_number = $ELEMENT_ID")"

IFS="|"
read -r NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< $QUERY

echo "The element with atomic number $ELEMENT_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."