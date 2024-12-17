#!/bin/bash

today=$(date)  # This calls the 'date' command and stores its output in the variable 'today'
echo "Today's date is $today."

echo "Machine uptime:$(uptime)." # Inline command substitution without a variable
