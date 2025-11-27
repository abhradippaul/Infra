#!/bin/bash

echo "analyzing log files"
echo "================================"

LOG_DIR="/mnt/c/Users/abhra/Desktop/Infra/bash/logs"
# APP_LOG_FILE="application.log"
# SYS_LOG_FILE="sys.log"
REPORT_FILE="$LOG_DIR/log_analysis_report.txt"
echo "analyzing log files" > "$REPORT_FILE"
echo "================================" > "$REPORT_FILE"
echo "analysing log files" > "$REPORT_FILE"

ERROR_PATTERNS=("ERROR" "FATAL" "CRITICAL")

echo -e "\nList of log files updated in last 24 hours"
LOG_FILES=$(find $LOG_DIR -name "*.log" -mtime -1)
echo $LOG_FILES

for LOG_FILE in $LOG_FILES; do
    for PATTERN in ${ERROR_PATTERNS[@]}; do
        echo -e "\nSearching $PATTERN logs in $LOG_FILE file"
        grep "$PATTERN" $LOG_FILE

        echo -e "\nNumber of $PATTERN logs in $LOG_FILE file"
        ERROR_COUNT=$(grep -c "$PATTERN" "$LOG_FILE")
        echo $ERROR_COUNT
        if [ "$ERROR_COUNT" -gt 10 ]; then
            echo "Action required"
        else 
            echo "Action not required"
        fi
    done
    echo "================================" > "$REPORT_FILE"
done