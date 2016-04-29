#!/bin/bash

PROJECTS_FOLDER=`dirname $PWD`

create_project(){
    local name=$1
    project_folder=${PROJECTS_FOLDER}/${name}
    mkdir -p ${project_folder}
    cp -r ${PROJECTS_FOLDER}/.example/* ${project_folder}
}

PROJECT_NAME=""
read_project_name(){
    local OUTPUT="/tmp/input.txt"
    # create empty file
    >$OUTPUT
    # cleanup  - add a trap that will remove $OUTPUT
    # if any of the signals - SIGHUP SIGINT SIGTERM it received.
    trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
    # show an inputbox
    dialog --title "Create Project" \
           --inputbox "Project Name" 8 60 2>$OUTPUT
    # get respose
    respose=$?
    # get data stored in $OUPUT using input redirection
    PROJECT_NAME=$(<$OUTPUT)
    # remove $OUTPUT file
    rm $OUTPUT
    return ${respose}
}


#
# Main
#

read_project_name
if [[ $? -ne 0 ]]; then
    echo "no project name given"
    exit
fi

if [[ -z ${PROJECT_NAME} ]]
then
    echo "will not create empty project name"
else
    create_project ${PROJECT_NAME}
fi

