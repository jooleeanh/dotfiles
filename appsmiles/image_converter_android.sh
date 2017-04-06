#!/bin/sh

METHOD="$1"
FILENAME="$2"
FILEPATH="$PWD/$FILENAME"
CPATH="$PWD/.."
ARG_LIST="[all/icon/splash/screen]"

CORRECT_FOLDER="drawable"

# TODO: convert method to lowercase
# METHOD="$(echo $METHOD | tr '[A-Z]' '[a-z]')"

# Checking proper arguments
if [[ $ARG_LIST != *"$METHOD"* ]]
then
  echo "Invalid 1st argument, choose one of the following: $ARG_LIST"; exit 1;
elif [[ $METHOD == "all" ]]
then
  continue
else
  if [ $# -lt 2 ]
  then
    echo "2 arguments required: $ARG_LIST and [filename]"; exit 1;
  elif [ ! -f "$PWD/$FILENAME" ]
  then
    echo "Invalid 2nd argument: file does not exist"; exit 1;
  fi
fi

function wrong_folder_message() {
  echo "Error: navigate to the $1 folder of your Android project, copy your images there and try again"
}

function success_message() {
  echo "$1 created for ldpi/mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi resolutions"
}

function create_folders_if_needed() {
  mkdir -p $CPATH/drawable-xxxhdpi
  mkdir -p $CPATH/drawable-xxhdpi
  mkdir -p $CPATH/drawable-xhdpi
  mkdir -p $CPATH/drawable-hdpi
  mkdir -p $CPATH/drawable-mdpi
  mkdir -p $CPATH/drawable-ldpi
}

function shared_maker() {
  SIZE=${#CORRECT_FOLDER}
  if [[ ${PWD: -$SIZE} == $CORRECT_FOLDER ]]; then
    create_folders_if_needed
    case $METHOD in
      icon)     convert_icon $FILEPATH;;
      splash)   convert_splash $FILEPATH;;
      screen)   convert_screen $FILEPATH;;
      all)      all_maker;;
    esac
  else
    wrong_folder_message $CORRECT_FOLDER
  fi
}

function all_maker() {
  for FILE in *.png
  do
    FILENAME=$FILE
    FILEPATH="$PWD/$FILE"
    case $FILE in
      ic_launcher.png)  convert_icon $FILEPATH;;
      splash.png)       convert_splash $FILEPATH;;
      screen*.png)      convert_screen $FILEPATH;;
    esac
  done
}
function convert_splash() {
  convert $1 -resize 1280x1920 $CPATH/drawable-xxxhdpi/splash.png
  convert $1 -resize 960x1440 $CPATH/drawable-xxhdpi/splash.png
  convert $1 -resize 640x960 $CPATH/drawable-xhdpi/splash.png
  convert $1 -resize 480x800 $CPATH/drawable-hdpi/splash.png
  convert $1 -resize 320x480 $CPATH/drawable-mdpi/splash.png
  convert $1 -resize 240x320 $CPATH/drawable-ldpi/splash.png
  success_message "splash.png"
}
function convert_screen() {
  NUMBER=$(echo "$FILENAME" | tr -dc '0-9')
  convert $1 -resize 1280x1920 $CPATH/drawable-xxxhdpi/screen$NUMBER.png
  convert $1 -resize 960x1440 $CPATH/drawable-xxhdpi/screen$NUMBER.png
  convert $1 -resize 640x960 $CPATH/drawable-xhdpi/screen$NUMBER.png
  convert $1 -resize 480x800 $CPATH/drawable-hdpi/screen$NUMBER.png
  convert $1 -resize 320x480 $CPATH/drawable-mdpi/screen$NUMBER.png
  convert $1 -resize 240x320 $CPATH/drawable-ldpi/screen$NUMBER.png
  success_message "screen$NUMBER.png"
}
function convert_icon() {
  convert $1 -resize 192x192 $CPATH/drawable-xxxhdpi/ic_launcher.png
  convert $1 -resize 144x144 $CPATH/drawable-xxhdpi/ic_launcher.png
  convert $1 -resize 96x96 $CPATH/drawable-xhdpi/ic_launcher.png
  convert $1 -resize 72x72 $CPATH/drawable-hdpi/ic_launcher.png
  convert $1 -resize 48x48 $CPATH/drawable-mdpi/ic_launcher.png
  convert $1 -resize 36x36 $CPATH/drawable-ldpi/ic_launcher.png
  success_message "ic_launcher.png"
}

# Root router for the 4 different functions.
shared_maker

## Use:
##    (you must be in drawable)
##      1) image_android all
##        (files must be named icon.png, splash.png and/or screen*.png)
##      2) image_android $1 $2
##        $1-icon/splash/screen
##        $2-filename
