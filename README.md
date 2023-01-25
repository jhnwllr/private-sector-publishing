
This repo builds the table here: 

https://docs.gbif-uat.org/private-sector-data-publishing/2.0/en/#table-01

Every month or on push changes, GitHub actions will automatically build the table 

## main workflow to update table

1. Edit `source.tsv` with **gbif.org** link to additional **private sector publishers**.

Add them at the bottom of table. Remember the table is `TAB` seperated so be sure to add a `	` between 
the **link** and **Activity sector** 
https://github.com/jhnwllr/private-sector-publishing/blob/main/data/source.tsv

2. Wait for GitHub actions to build the table. 
https://github.com/jhnwllr/private-sector-publishing/actions

3. Look for the generated tables here: 
https://github.com/jhnwllr/private-sector-publishing/tree/main/exports

Probably you want the ones from these folders: 
https://github.com/jhnwllr/private-sector-publishing/tree/main/exports/table
https://github.com/jhnwllr/private-sector-publishing/tree/main/exports/totals

## scheduled builds 

Once a month a new table will be generated, even if `source.tsv` is not updated. 
