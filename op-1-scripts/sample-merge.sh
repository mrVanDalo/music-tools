#!/bin/bash


# CONFIGURATION

# normalize sound to this db
NORM_DB_LEVEL=-8

# normalize sound to this samplerate
NORM_SAMPLE_RATE=44100


# folder to work in
WORK_FOLDER=/dev/shm/work
OUTPUT_FOLDER=/dev/shm
OUTPUT_FILE=my_output.wav
OUTPUT_FILE_TMP=my_output_tmp.wav

#
# make sure folder is clear
#
if [[ -d $WORK_FOLDER ]]
then
    rm -rf $WORK_FOLDER
fi
mkdir -p $WORK_FOLDER

IFS="
"

#
# normalize samples
#
for input in `ls | grep -v json$`
do
    sox \
        $input \
        $WORK_FOLDER/$input \
        channels 2 \
        rate $NORM_SAMPLE_RATE
done

#
# merge all samples
#

# create empty file to start
sox --null \
    --channels 2 \
    --rate $NORM_SAMPLE_RATE \
    $OUTPUT_FOLDER/$OUTPUT_FILE \
    trim 0 0


# merge
for input in `ls $WORK_FOLDER`
do
    sox \
        $OUTPUT_FOLDER/$OUTPUT_FILE \
        $WORK_FOLDER/$input \
        $OUTPUT_FOLDER/$OUTPUT_FILE_TMP
    mv \
        $OUTPUT_FOLDER/$OUTPUT_FILE_TMP \
        $OUTPUT_FOLDER/$OUTPUT_FILE
done


