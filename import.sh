#!/bin/bash

WORK_DIR=$HOME/G-NAF
GNAF_ZIP=$HOME/aug18_gnaf_pipeseparatedvalue_20180827115521.zip
GNAF_DIR=$WORK_DIR/AUG18_GNAF_PipeSeparatedValue_20180827115521/G-NAF
DATABASE=$WORK_DIR/G-NAF.db
RELEASE="G-NAF AUGUST 2018"
STATES="ACT NSW NT OT QLD SA TAS VIC WA"
AUT_FILES="FLAT_TYPE_AUT LEVEL_TYPE_AUT STREET_SUFFIX_AUT STREET_CLASS_AUT STREET_TYPE_AUT GEOCODE_TYPE_AUT GEOCODED_LEVEL_TYPE_AUT"
STD_FILES="ADDRESS_DETAIL STREET_LOCALITY LOCALITY ADDRESS_DEFAULT_GEOCODE STATE"

# Unzip G-NAF archive
mkdir -p $WORK_DIR && unzip $GNAF_ZIP -d $WORK_DIR

# Import Authority Code data
for AUT_FILE in $AUT_FILES
do
  echo "Importing Authority_Code_${AUT_FILE}_psv.psv"
  sqlite3 $DATABASE ".import '${GNAF_DIR}/${RELEASE}/Authority Code/Authority_Code_${AUT_FILE}_psv.psv' ${AUT_FILE}"
done

# Import Standard data
for STD_FILE in $STD_FILES
do
  for STATE in $STATES
  do
    echo "Importing ${STATE}_${STD_FILE}_psv.psv"
    sqlite3 $DATABASE ".import '${GNAF_DIR}/${RELEASE}/Standard/${STATE}_${STD_FILE}_psv.psv' ${STD_FILE}"
  done
  echo "Cleaning up header rows from ${STD_FILE}"
  sqlite3 $DATABASE "DELETE FROM ${STD_FILE} WHERE ${STD_FILE}_PID = '${STD_FILE}_PID';"
done
