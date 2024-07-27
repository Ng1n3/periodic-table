#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"


MENU() {
  if [[ $1 ]]
  then
    if [[ $1 =~ ^[0-9]+$ ]]
      then 
         ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'" | sed -E 's/^ *| *$//g')
      else
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'" | sed -E 's/^ *| *$//g')
    fi

    if [[ -n $ATOMIC_NUMBER ]]
      then
         ELEMENT_NAME=$($PSQL "SELECT name from elements WHERE atomic_number='$ATOMIC_NUMBER'" | sed -E 's/^ *| *$//g')
         ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ATOMIC_NUMBER'"  | sed -E 's/^ *| *$//g')
         ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties where atomic_number='$ATOMIC_NUMBER'" | sed -E 's/^ *| *$//g')
         ELEMENT_TYPE=$($PSQL "SELECT types.type FROM types JOIN properties USING (type_id) WHERE atomic_number='$ATOMIC_NUMBER'" | sed -E 's/^ *| *$//g')
         ELEMENT_BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'" | sed -E 's/^ *| *$//g')
         ELEMENT_MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'" | sed -E 's/^ *| *$//g')
         echo -e "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MP celsius and a boiling point of $ELEMENT_BP celsius."
      else
        echo "I could not find that element in the database."
    fi
  else
    echo -e "Please provide an element as an argument."
  fi
}

MENU "$1"