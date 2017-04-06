#!/bin/sh

function _remote() { git remote -v; }
REMOTE=_remote
REMOTE="$REMOTE"
re="git@gitlab.appsmiles.eu:appsmiles/(.*).git"

arrIN=(${REMOTE//origin/ })
echo $arrIN

#printf $REMOTE
#if [[ $REMOTE =~ $re ]]; then echo ${BASH_REMATCH[1]}; fi

#re='appsmiles'
#if [[ $REMOTE ~= $re ]]; then echo "hi"; fi;

#IFS=$':'; arrIN=(${REMOTE//$IFS/ }); unset IFS;
#${arrIN[0]}
