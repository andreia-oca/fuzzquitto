#!/bin/bash

outputdir=output_3-08-2022
covfile=cov_over_time.csv

# Clean environment
gcovr -r ./src/mosquitto -d

# Dump code coverage during runtime
kill -SIGUSR2 $(pidof ./fuzzquitto/src/mosquitto)
time=$(date +%s)

# Get coverage data
cov_data=$(gcovr -r ./src/ -s | grep "[lb][a-z]*:")
l_per=$(echo "$cov_data" | grep lines | cut -d" " -f2 | rev | cut -c2- | rev)
l_abs=$(echo "$cov_data" | grep lines | cut -d" " -f3 | cut -c2-)
b_per=$(echo "$cov_data" | grep branch | cut -d" " -f2 | rev | cut -c2- | rev)
b_abs=$(echo "$cov_data" | grep branch | cut -d" " -f3 | cut -c2-)

echo "$time,$l_per,$l_abs,$b_per,$b_abs" >> $covfile
