#!/bin/bash
eval `ssh-agent -s`
ssh-add

# cd /mnt/c/Users/ftw712/Desktop/

# ssh jwaller@c5gateway-vh.gbif.org "hdfs dfs -rm -r stats.parquet"
# scp -r scala/stats.scala jwaller@c5gateway-vh.gbif.org:/home/jwaller/
# ssh jwaller@c5gateway-vh.gbif.org "spark2-shell -i stats.scala"
# ssh jwaller@c5gateway-vh.gbif.org 'bash -s' < shell/export_parquet.sh stats
# shell/download_parquet.sh stats

# Rscript.exe --vanilla R/stats.R

