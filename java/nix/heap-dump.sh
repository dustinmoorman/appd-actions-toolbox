#!/bin/bash

JCMD_PATH_PART="java8/bin/jcmd"
HEAP_DUMP_PATH="/path/to/your/dumps"
JCMD_COMMAND="jcmd"
JCMD_COMMAND_BACKUP="/usr/local/test/java/java8/bin/jcmd"

ENABLE_SAFE_MODE="true"

### WIP: Safe mode stuff, making sure we have our requirements. 
## Turn off if you want to hack it to work with your setup

set -e

if [[ $(command -v jcmd) != "" ]] && [[ "${ENABLE_SAFE_MODE}" == "true" ]]; then
  echo "JCMD Exists in path"
else
  if [[ $(echo "${JAVA_HOME_BACKUP}${JCMD_PATH_PART}") ]] && [[ "${ENABLE_SAFE_MODE}" == "true" ]]; then
    echo "No JCMD, setting to JCMD_COMMAND_BACKUP (script defined): ${JCMD_COMMAND_BACKUP}"
    JCMD_COMMAND="${JCMD_COMMAND_BACKUP}"
  fi
fi

# [ END safe mode checks ] ##################################################

JAVA_PIDS=$(pidof java)

for PID in ${JAVA_PIDS}
do
  if [[ "${ENABLE_SAFE_MODE}" == "true" ]]; then
    echo "Java pid ${PID} found, creating heap dump at ${HEAP_DUMP_PATH}/java-${PID}.dump"
  fi
  ${JCMD_COMMAND} ${PID} GC.heap_dump "${HEAP_DUMP_PATH}/java-${PID}.dump"
done
