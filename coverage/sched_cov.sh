#!/bin/bash

outputdir=output_3-08-2022
covfile=cov_over_time.csv

# Clean environment
rm $outputdir/$covfile; touch $outputdir/$covfile

while 1
do
	./cov_script.sh
	sleep 10m
done
