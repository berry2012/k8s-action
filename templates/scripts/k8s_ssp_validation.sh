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
    # k8s policies https://www.checkov.io/5.Policy%20Index/kubernetes.html
    # checkov -s -d .
    # no policy skipped
    # checkov -o junitxml --framework kubernetes -d ./kubernetes >checkov.xml
    # skip some checks - https://www.checkov.io/2.Basics/Suppressing%20and%20Skipping%20Policies.html
    checkov -o junitxml --framework kubernetes -d ./kubernetes --skip-check CKV_K8S_37,CKV_K8S_28,CKV_K8S_43,CKV_K8S_8,CKV_K8S_9,CKV_K8S_40,CKV_K8S_21,CKV_K8S_23,CKV2_K8S_6,CKV_K8S_35 >checkov.xml
    
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


if (( $k8sCheckovOutput != 0 ))
then
  echo "## ERROR : Checkov Validation Test Failed - Check CodeBuild Test Report"
  echo "error code: $k8sCheckovOutput"
fi