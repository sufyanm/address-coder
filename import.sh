#!/bin/bash

WORK_DIR=/tmp/g-naf
GNAF_ZIP=/tmp/nov16gnafpipeseparatedvalue.zip
GNAF_DIR=$WORK_DIR/NOV16_GNAF_PipeSeparatedValue/G-NAF
DATABASE=$WORK_DIR/g-naf.db
STATES="ACT NSW NT OT QLD SA TAS VIC WA"
AUT_FILES="FLAT_TYPE_AUT LEVEL_TYPE_AUT STREET_SUFFIX_AUT STREET_CLASS_AUT STREET_TYPE_AUT GEOCODE_TYPE_AUT GEOCODED_LEVEL_TYPE_AUT"
STD_FILES="ADDRESS_DETAIL STREET_LOCALITY LOCALITY ADDRESS_DEFAULT_GEOCODE STATE"

# Install unzip, sqlite

# Create WORK_DIR
mkdir -p $WORK_DIR

# Unzip G-NAF archive
unzip -P $WORK_DIR $GNAF_ZIP

# Import Authority Code data
for AUT_FILE in $AUT_FILES
do
  echo "Importing Authority_Code_${AUT_FILE}_psv.psv"
  sqlite3 $DATABASE ".import '${GNAF_DIR}/G-NAF NOVEMBER 2016/Authority Code/Authority_Code_${AUT_FILE}_psv.psv' ${AUT_FILE}"
done

# Import Standard data
for STD_FILE in $STD_FILES
do
  for STATE in $STATES
  do
    echo "Importing ${STATE}_${STD_FILE}_psv.psv"
    sqlite3 $DATABASE ".import '${GNAF_DIR}/G-NAF NOVEMBER 2016/Standard/${STATE}_${STD_FILE}_psv.psv' ${STD_FILE}"
  done
  echo "Cleaning up header rows from ${STD_FILE}"
  sqlite3 $DATABASE "DELETE FROM ${STD_FILE} WHERE ${STD_FILE}_PID = '${STD_FILE}_PID';"
done
