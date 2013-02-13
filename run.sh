#!/bin/bash
function currentDir(){
   DIR=`readlink -f $0`
   DIR=`dirname $DIR`
}
function isExecutedInDevelenv(){
   if [ "`id -nu`" == "develenv" ]; then
      isDevelenv="true"
   else
      isDevelenv="false"
   fi
}

function getJMeterHome(){
   isExecutedInDevelenv
   if [ "$isDevelenv" == "false" ]; then
      jmeterPath=$(which jmeter.sh)
      [[ "$jmeterPath" == "" ]] && echo "[ERROR] Jmeter debería estar en el path" && exit 1
      JMETER_HOME=$(dirname $(dirname $jmeterPath))
   else
      JMETER_HOME="/home/develenv/platform/jmeter"
   fi
   export JMETER_HOME
}

function init(){
   currentDir
   getJMeterHome
   WORKSPACE=$DIR
   OUTPUT_DIR=${WORKSPACE}/target/
   OUTPUT_REPORTS_DIR=$OUTPUT_DIR/reports
   LOG_DIR=$OUTPUT_DIR/logs
   rm -Rf $OUTPUT_DIR $OUTPUT_REPORTS_DIR
   mkdir -p $OUTPUT_DIR $OUTPUT_REPORTS_DIR $LOG_DIR
   JTL_FILE="${OUTPUT_REPORTS_DIR}/jmeter-example.jtl"
}

function execute(){
   ${JMETER_HOME}/bin/jmeter.sh -n -j "${LOG_DIR}/jmeter-example.log" -l "${JTL_FILE}" -t "./develenv.jmx"
}

function reports(){
   # Convertir informe a HTML
   cd reports
   "./jmeter_report_to_html.sh" "${JTL_FILE}" "$OUTPUT_REPORTS_DIR"
   # Generar resumen
   "./create_jmeter_summary.sh" "${JTL_FILE}" "$OUTPUT_REPORTS_DIR"
   # Convertir informe a HTML (con xalan)
   java -classpath ${JMETER_HOME}/lib/xalan-2.7.1.jar:${JMETER_HOME}/lib/serializer-2.7.1.jar org.apache.xalan.xslt.Process -IN "${JTL_FILE}" -XSL "${JMETER_HOME}/extras/jmeter-results-report_21.xsl" -OUT "$OUTPUT_REPORTS_DIR/jmeter-example-xalan.html"
  ./develenv_jtl "${JTL_FILE}"
  ./jtl2html "${JTL_FILE}"
   cd -
}

init
execute
reports



