#!/bin/bash
#--------------------------------------------------------
# Purpose: Insert CSV data into OpenSpecimen Table
# Author: Kaustubh Wadagavi
# -------------------------------------------------------

INPUT_FILE=patient.csv

OLDIFS=$IFS
IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit 99; }
while read PART_SOURCE_ID SOURCE FIRST_NAME MIDDLE_NAME LAST_NAME BIRTH_DATE ETHNICITY GENDER VITAL_STATUS DEATH_DATE ACTIVITY_STATUS UPDATED_TIME DATA_EXTRACT_DATE
do      
	if [ -z "$DEATH_DATE" ]
	then
	    DEATH_DATE=null;
	    mysql -uos-test -p'Login@123' -Dos_test << EOF
	    INSERT INTO os_staged_participants (
		 EMPI_ID,
		 SOURCE,
		 FIRST_NAME,
		 MIDDLE_NAME,
		 LAST_NAME,
		 BIRTH_DATE,
		 #ETHNICITY,
		 GENDER,
		 VITAL_STATUS,
		 DEATH_DATE,
		 ACTIVITY_STATUS,
		 UPDATED_TIME
		) 
	   VALUES (
		$PART_SOURCE_ID,
		$SOURCE,
		$FIRST_NAME,
		$MIDDLE_NAME,
	        $LAST_NAME,
		STR_TO_DATE('$BIRTH_DATE','%d-%b-%Y'),
		#$ETHNICITY,
		$GENDER,
		$VITAL_STATUS,
		$DEATH_DATE,
		$ACTIVITY_STATUS,
		STR_TO_DATE('$UPDATED_TIME', '%d-%b-%Y')
 		)
EOF
	else 
	   mysql -uos-test -p'Login@123' -Dos_test << EOF
           INSERT INTO os_staged_participants (
                 EMPI_ID,
                 SOURCE,
                 FIRST_NAME,
                 MIDDLE_NAME,
                 LAST_NAME,
                 BIRTH_DATE,
                 GENDER,
               	 VITAL_STATUS,
                 DEATH_DATE,
                 ACTIVITY_STATUS,
                 UPDATED_TIME
                )
           VALUES (
                $PART_SOURCE_ID,
                $SOURCE,
                $FIRST_NAME,
                $MIDDLE_NAME,
                $LAST_NAME,
                STR_TO_DATE('$BIRTH_DATE','%d-%b-%Y'),
                $GENDER,
                $VITAL_STATUS,
		STR_TO_DATE('$DEATH_DATE','%d-%b-%Y'),
                $ACTIVITY_STATUS,
                STR_TO_DATE('$UPDATED_TIME','%d-%b-%Y')
                )
EOF
	fi
done < <(tail -n +2 $INPUT_FILE)
IFS=$OLDIFS
