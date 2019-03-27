#!/bin/bash

#
# Environment variables
#

# The id of the toolchain that shows up on the brower URL
export TOOLCHAIN_ID="1cfc3bd9-3891-4a9d-8503-e1cb10333e38"

# API Key of the user
export IBM_CLOUD_API_KEY="5nolj6lyv65L6dEZbuAzK5sGLgWmw9VXCFO7xqwoUCwI"
export MY_APP_NAME="Weather Application"
export MY_BUILD_NUMBER="master:1"

# Set the value to true to see detail CLI logs
#export IBMCLOUD_TRACE=true

# Log into IBM Cloud CLI
ibmcloud login -a api.ng.bluemix.net --apikey $IBM_CLOUD_API_KEY --no-region

#
# Upload a build record for this build, It is assumed that the build was successful
ibmcloud doi publishbuildrecord --logicalappname=$MY_APP_NAME --buildnumber=$MY_BUILD_NUMBER --branch=master --repositoryurl=https://github.com/open-toolchain/dra-toolchain-demo --commitid=2b5fd14 --status=pass

#
# Upload unittest test record for the build
ibmcloud doi publishtestrecord --logicalappname=$MY_APP_NAME --buildnumber=$MY_BUILD_NUMBER --filelocation=mocha_pass.json --type=unittest

#
# Upload CodeCoverge test record for the build
ibmcloud doi publishtestrecord --logicalappname=$MY_APP_NAME --buildnumber=$MY_BUILD_NUMBER --filelocation=istanbul_pass.json --type=code

#
# Invoke a DevOps Insights gate to evaluated a policy based on uploaded data
ibmcloud doi evaluategate --logicalappname=$MY_APP_NAME --buildnumber=$MY_BUILD_NUMBER --policy=FirstPolicy

#
# Upload a deployment record, It is assumed that the deployment was successful
ibmcloud doi publishdeployrecord --logicalappname=$MY_APP_NAME --buildnumber=$MY_BUILD_NUMBER --joburl="cloud.ibm.com" --env=dev --status=pass
