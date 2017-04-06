#!/bin/sh

METHOD="$1"
FILENAME="$2"
FILEPATH="$PWD/$FILENAME"
CPATH="$PWD"
ARG_LIST="[all/icon/splash/screen]"

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
  echo "Error: navigate to the $1 folder of your iOs project, copy your images there and try again"
}

function icon_maker() {
  CORRECT_FOLDER="AppIcon.appiconset"
  SIZE=${#CORRECT_FOLDER}
  if [[ ${PWD: -$SIZE} == $CORRECT_FOLDER ]]; then
    convert_icon $1
  else
    wrong_folder_message $CORRECT_FOLDER
  fi
};

function splash_maker() {
  CORRECT_FOLDER="LaunchImage.launchimage"
  SIZE=${#CORRECT_FOLDER}
  if [[ ${PWD: -$SIZE} == $CORRECT_FOLDER ]]; then
    convert_splash $1
  else
    wrong_folder_message $CORRECT_FOLDER
  fi
};

function screen_maker() {
  CORRECT_FOLDER=".imageset"
  SIZE=${#CORRECT_FOLDER}
  if [[ ${PWD: -$SIZE} == $CORRECT_FOLDER ]]; then
    NUMBER=$(echo "$FILENAME" | tr -dc '0-9')
    convert_screen $1
  else
    wrong_folder_message $CORRECT_FOLDER
  fi
}

function all_maker() {
  for FILE in *.png
  do
    FILEPATH="$PWD/$FILE"
    case $FILE in
      icon.png)    CPATH="$PWD/AppIcon.appiconset"; convert_icon $FILEPATH;;
      splash.png)  CPATH="$PWD/LaunchImage.launchimage"; convert_splash $FILEPATH ;;
      screen*.png)
      NUMBER=$(echo "$FILE" | tr -dc '0-9')
      CPATH="$PWD/Screen$NUMBER.imageset"
      mkdir -p $CPATH
      convert_screen $FILEPATH
      ;;
    esac
  done
}

function convert_icon() {
  convert $1 -resize 20x20 $CPATH/Icon-20.png
  convert $1 -resize 29x29 $CPATH/Icon-29.png
  convert $1 -resize 40x40 $CPATH/Icon-40.png
  convert $1 -resize 40x40 $CPATH/Icon-40-2.png
  convert $1 -resize 40x40 $CPATH/Icon-40-3.png
  convert $1 -resize 58x58 $CPATH/Icon-58.png
  convert $1 -resize 58x58 $CPATH/Icon-58-2.png
  convert $1 -resize 60x60 $CPATH/Icon-60.png
  convert $1 -resize 76x76 $CPATH/Icon-76.png
  convert $1 -resize 80x80 $CPATH/Icon-80.png
  convert $1 -resize 80x80 $CPATH/Icon-80-2.png
  convert $1 -resize 87x87 $CPATH/Icon-87.png
  convert $1 -resize 120x120 $CPATH/Icon-120.png
  convert $1 -resize 120x120 $CPATH/Icon-120-2.png
  convert $1 -resize 152x152 $CPATH/Icon-152.png
  convert $1 -resize 167x167 $CPATH/Icon-167.png
  convert $1 -resize 180x180 $CPATH/Icon-180.png
  echo "iOs icons generated for all resolutions"
}

function convert_splash() {
  convert $1 -resize 640x960 $CPATH/splash-960h.png
  convert $1 -resize 640x1136 $CPATH/splash-1136h.png
  convert $1 -resize 750x1334 $CPATH/splash-1334h.png
  convert $1 -resize 1242x2208 $CPATH/splash-2208h.png
  echo "iOs splashes generated for all resolutions"
}

function convert_screen() {
  convert $1 -resize 640x1136 $CPATH/screen$NUMBER@2x.png
  convert $1 -resize 960x1704 $CPATH/screen$NUMBER@3x.png
  echo "iOs screen$NUMBER generated for all resolutions"
}

# Root router for the 4 different functions.
case $METHOD in
  "icon")   icon_maker $FILEPATH;;
  "splash") splash_maker $FILEPATH;;
  "screen") screen_maker $FILEPATH;;
  "all")    all_maker;;
esac

## Use:
##      1) image_ios all
##        (you must be in Images.xcassets)
##        (files must be named icon.png, splash.png or screen*.png)
##      2) image_ios $1 $2
##        $1-icon/splash/screen
##        $2-filename
##        (you must be in appropriate folder)
