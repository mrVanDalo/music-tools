#!/bin/bash


set -x

BASE_PATH=~/projects

export PATH=$PATH:~/bin

# sets $PROJECT_PATH
load_project(){
    local project_name=$1
    local project_path=$BASE_PATH/$project_name
    if [[ ! -d $project_path ]]
    then
        echo "project path $project_path for $project_name is not a directory"
        exit 1
    fi
    PROJECT_PATH=$project_path
}

start_programs(){
    if [[ -x $PROJECT_PATH/start.sh ]]
    then
        cd $PROJECT_PATH
        exec $PROJECT_PATH/start.sh
    else
        echo "could not find start.sh in $PROJECT_PATH"
        exit 1
    fi
}

# set CURRENT_PROJECT
choose_project_dialog(){
    menu=()
    for project in `ls $BASE_PATH | sort --reverse`
    do
        local project_text_file=$BASE_PATH/$project/info
        local project_text=""
        if [[ -f $project_text_file ]]
        then
            project_text=`head -n 1 $project_text_file`
        fi
        menu+=($project "$project_text")
    done
    dialog --menu "Projects" 0 0 0 "${menu[@]}" 2> .menu
    CURRENT_PROJECT=$(<.menu)
}

open_project(){
    choose_project_dialog
    load_project $CURRENT_PROJECT
    start_programs
    sleep 10s ; rewire_jack
}

open_project
read 
