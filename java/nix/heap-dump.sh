#!/bin/bash

ENABLE_SAFE_MODE="true"
JAVA_HOME_BACKUP="/usr/local/test/java/"
JCMD_PATH_PART="java8/bin/jcmd"
HEAP_DUMP_PATH="/path/to/your/dumps"
JCMD_COMMAND="jcmd"

### WIP: Safe mode stuff, making sure we have our requirements. 
## Turn off if you want to hack it to work with your setup

set -e

if [[ -z "${JAVA_HOME}" ]] && [[ "${ENABLE_SAFE_MODE}" == "true" ]]; then
  echo "No JAVA_HOME set, using JAVA_HOME_BACKUP (script defined): ${JAVA_HOME_BACKUP}"
fi

if [[ $(command -v jcmd) != "" ]] && [[ "${ENABLE_SAFE_MODE}" == "true" ]]; then
  echo "JCMD Exists in path"
else
  if [[ $(echo "${JAVA_HOME_BACKUP}${JCMD_PATH_PART}") ]] && [[ "${ENABLE_SAFE_MODE}" == "true" ]]; then
    echo "No JCMD, trying JAVA_HOME_BACKUP with JCMD_PATH_PART"
    JCMD_COMMAND="${JAVA_HOME_BACKUP}${JCMD_PATH_PART}"
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
