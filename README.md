# G-NAF

This repository contains scripts to work with Australia's Geocoded National Address File (G-NAF).

## Importing to a SQLite database

* Install required packages `yum -y install unzip sqlite`.
* Download the G-NAF data set from [https://data.gov.au/dataset/geocoded-national-address-file-g-naf](https://data.gov.au/dataset/geocoded-national-address-file-g-naf). The file should be placed in your home directory.
* Start the import `./import.sh`.

## Known issues

* `Error: no such table: FLAT_TYPE` is caused by older version of SQLite in Linux distributions such as Red Hat Enterprise Linux 7 and CentOS 7. A newer version of SQLite is required.
