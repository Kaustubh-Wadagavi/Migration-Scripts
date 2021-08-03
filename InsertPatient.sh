#!/bin/bash
#--------------------------------------------------------
# Purpose: Insert CSV data into OpenSpecimen Table
# Author: Kaustubh Wadagavi
# -------------------------------------------------------

INPUT_FILE=patient.csv


OLDIFS=$IFS
IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit 99; }
while read PART_SOURCE_ID PART_SOURCE FIRST_NAME MIDDLE_NAME LAST_NAME DATE_OF_BIRTH ETHNICITY GENDER VITAL_STATUS DEATH_DATE STATUS PAT_UPDATE_DATE DATA_EXTRACT_DATE
do
	mysql -uos-test -p'Login@123' -Dos_test << EOF
	INSERT INTO os_staged_participants 
		(
		 PART_SOURCE_ID,
		 PART_SOURCE,
		 FIRST_NAME,
		 MIDDLE_NAME,
		 LAST_NAME,
		 DATE_OF_BIRTH,
		 ETHNICITY,
		 GENDER,
		 VITAL_STATUS,
		 DEATH_DATE,
		 STATUS,
		 PAT_UPDATE_DATE,
		 DATA_EXTRACT_DATE
		) 
	VALUES 	(
		$PART_SOURCE_ID,
		$PART_SOURCE,
		$FIRST_NAME,
		$MIDDLE_NAME,
	        $LAST_NAME,
		$DATE_OF_BIRTH,
		$ETHNICITY,
		$GENDER,
		$VITAL_STATUS,
		$DEATH_DATE,
		$STATUS,
		$PAT_UPDATE_DATE,
		$DATA_EXTRACT_DATE 
 		)
EOF
done < <(tail -n +2 $INPUT_FILE)
IFS=$OLDIFS
