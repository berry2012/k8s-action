#This solution, non-production-ready template describes AWS Codepipeline based CICD Pipeline for kubernetes code deployment.


#!/bin/bash

# Accept Command Line Arguments
SKIPVALIDATIONFAILURE=$1
k8sCheckov=$2
# -----------------------------

echo "### VALIDATION Overview ###"
echo "-------------------------"
echo "Skip Validation Errors on Failure : ${SKIPVALIDATIONFAILURE}"
echo "Kubernetes checkov  : ${k8sCheckov}"
echo "------------------------"

if (( ${k8sCheckov} == "Y"))
then
    echo "## VALIDATION : Running checkov ..."
    #checkov -s -d .
    checkov -o junitxml --framework kubernetes -d ./kubernetes >checkov.xml
fi
k8sCheckovOutput=$?

echo "## VALIDATION Summary ##"
echo "------------------------"
echo "Kubernetes checkov  : ${k8sCheckovOutput}"
echo "------------------------"

if (( ${SKIPVALIDATIONFAILURE} == "Y" ))
then
  #if SKIPVALIDATIONFAILURE is set as Y, then validation failures are skipped during execution
  echo "## VALIDATION : Skipping validation failure checks..."
elif (( $k8sCheckovOutput == 0 ))
then
  echo "## VALIDATION : Checks Passed!!!"
else
  # When validation checks fails, build process is halted.
  echo "## ERROR : Validation Failed"
  exit 1;
fi