#!/bin/sh

case $1 in
    "apmmanager")       PROJECT_ID=2 ;;
    "apmapi")           PROJECT_ID=7 ;;
    "android-services") PROJECT_ID=16 ;;
    "android-apm")      PROJECT_ID=18 ;;
    "android-demos")    PROJECT_ID=22 ;;
    "ios-services")     PROJECT_ID=15 ;;
    "ios-apm")          PROJECT_ID=17 ;;
    "ios-demos")        PROJECT_ID= 21 ;;
    "ps-and")           PROJECT_ID=24 ;;
    "ps-ios")           PROJECT_ID=23 ;;
    *) PROJECT_ID=$1 ;;
esac

echo $PROJECT_ID;
