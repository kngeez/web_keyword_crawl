#!/bin/bash

TODAYS_DATE=`date '+%Y%m%d'`
LOG_FILE=error_output_$TODAYS_DATE.txt
OUTPUT=output_$TODAYS_DATE.txt

./spider_website.rb &> ./Output/$LOG_FILE ?> ./Output/$OUTPUT

mutt -s "Results" -a ~/Projects/ruby/results.csv -- kng@marchex.com < /dev/null
