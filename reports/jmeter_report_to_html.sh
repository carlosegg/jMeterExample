#!/bin/bash
if test $# -lt 2
then
  echo "Usage: $0 jmeter-jtl-file jmeter-scripts-path"
  exit
fi

JTL_FILE=$1
SCRIPTS_PATH=$2

if [ ! -e "${JTL_FILE}" ]
then
  echo "${JTL_FILE} not found"
  exit
fi

if [ ! -e "${SCRIPTS_PATH}" ]
then
  echo "${SCRIPTS_PATH} not found"
  exit
fi

# Extraer nombre del fichero .jtl
JTL_NAME=`echo ${JTL_FILE} | sed 's/.*\///' | sed 's!\(.*\)\..*!\1!'`
# Extraer directorio del fichero .jtl
REPORTS_PATH=`echo ${JTL_FILE} | sed 's!\(.*\)/.*!\1/!'`

export CLASSPATH="./lib/saxon9he.jar"

# Convertir informe a HTML
java net.sf.saxon.Transform -s:"${JTL_FILE}" -xsl:"$JMETER_HOME/extras/jmeter-results-report_21.xsl" -o:"${REPORTS_PATH}/${JTL_NAME}.html"

