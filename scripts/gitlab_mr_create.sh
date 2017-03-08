#!/bin/sh

TITLE=$2
SOURCE_BRANCH=`$SCRIPT_FOLDER_PATH/git_current_branch.sh`
TARGET_BRANCH="master"
PROJECT_ID=`$SCRIPT_FOLDER_PATH/gitlab_match_project.sh $1`

if [ $# -eq 3 ]
    then
        ASSIGNEE_ID=`$SCRIPT_FOLDER_PATH/gitlab_match_assignee.sh $3`
fi


function _merge_request() { gitlab project-merge-request create --project-id $PROJECT_ID --source-branch $SOURCE_BRANCH --target-branch $TARGET_BRANCH --title $TITLE $ASSIGNEE_ID; };
_merge_request

# Use:
#       glmr
#       $1-PROJECT_NAME
#       $2-TITLE
#       $3-ASSIGNEE_NAME
