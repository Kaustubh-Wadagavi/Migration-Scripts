#!/bin/bash
#--------------------------------------------------------
# Purpose: Insert Medical record's OpenSpecimen Table
# Author: Kaustubh Wadagavi
# -------------------------------------------------------

INPUT_FILE=mrn.csv

OLDIFS=$IFS
IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit 99; }
while read PART_SOURCE_ID PART_SOURCE FACILITY_TYPE_ID SITE_NAME NEW_MRN_VALUE DATA_EXTRACT_DATE
do  
    PARTICIPANT_ID=$(mysql os_test -uos-test -p'Login@123' -se "SELECT IDENTIFIER FROM os_staged_participants where EMPI_ID=$PART_SOURCE_ID")
    echo $PARTICIPANT_ID    
    mysql -uos-test -p'Login@123' -Dos_test << EOF
    INSERT INTO os_staged_part_medical_ids (
		 MEDICAL_RECORD_NUMBER,
 		 SITE_NAME,
		 PARTICIPANT_ID
	    )
	    values (
		 $NEW_MRN_VALUE,
		 $SITE_NAME,
	         $PARTICIPANT_ID
	    ) 
EOF
done < <(tail -n +2 $INPUT_FILE)
IFS=$OLDIFSi
