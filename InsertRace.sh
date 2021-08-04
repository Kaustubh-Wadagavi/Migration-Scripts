#!/bin/bash
#--------------------------------------------------------
# Purpose: Insert Medical record's OpenSpecimen Table
# Author: Kaustubh Wadagavi
# -------------------------------------------------------

INPUT_FILE=race.csv

OLDIFS=$IFS
IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit 99; }
while read PART_SOURCE_ID PART_SOURCE RACE_VALUE
do
    PARTICIPANT_ID=$(mysql os_test -uos-test -p'Login@123' -se "SELECT IDENTIFIER FROM os_staged_participants where EMPI_ID=$PART_SOURCE_ID")

    if [[ ! -z "$PARTICIPANT_ID" ]]
    then
         mysql -uos-test -p'Login@123' -Dos_test <<- EOF
         INSERT INTO os_staged_participant_races (
              RACE_NAME,
              PARTICIPANT_ID
            )
            values (
              $RACE_VALUE,
	      $PARTICIPANT_ID,
	    )
        EOF
    fi
done < <(tail -n +2 $INPUT_FILE)
IFS=$OLDIFSi

