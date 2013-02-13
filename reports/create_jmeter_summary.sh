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
TEMPLATES_HOME="`pwd`/templates"
export CLASSPATH="`pwd`/lib/saxon9he.jar"

# Si es la primera ejecucion se crea el fichero con las cabeceras
SUMMARY_FILE="`pwd`/${JTL_NAME}_summary.txt"
if [ ! -e "${SUMMARY_FILE}" ]
then
  cp "$TEMPLATES_HOME/summary-initial.txt" "${SUMMARY_FILE}"
fi

# Extraer datos de la ejecucion y guardarlos en summary.txt
java net.sf.saxon.Transform -s:"${JTL_FILE}" -xsl:"$TEMPLATES_HOME/jmeter-summary.xsl" -o:"${REPORTS_PATH}/jmeter-summary-aux.txt"
cd "${REPORTS_PATH}"
data=`cat jmeter-summary-aux.txt`
echo $data >> "${SUMMARY_FILE}"
java net.sf.saxon.Transform -o:"${REPORTS_PATH}/jmeter-summary-aux.xml" -it:main -xsl:"$TEMPLATES_HOME/csv-to-xml_v2.xslt" pathToCSV="${SUMMARY_FILE}"

# Convertir resumen a HTML
java net.sf.saxon.Transform -s:"${REPORTS_PATH}/jmeter-summary-aux.xml" -xsl:"$TEMPLATES_HOME/jmeter-summary-table.xsl" -o:"${REPORTS_PATH}/${JTL_NAME}_summary.html"

