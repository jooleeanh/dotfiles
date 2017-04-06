#!/bin/sh

PROJECT_ID=`$SCRIPT_PATH/gitlab_match_project.sh $1`
MERGE_REQUEST_ID=$2
RM_SOURCE_BRANCH=''

if [ $# -eq 3 ]
    then
        SOURCE_BRANCH=`$SCRIPT_PATH/git_current_branch.sh`
        RM_SOURCE_BRANCH='--should-remove-source-branch $SOURCE_BRANCH'
fi


function _merge_request() { gitlab project-merge-request merge --project-id $PROJECT_ID --id $MERGE_REQUEST_ID $RM_SOURCE_BRANCH; };
_merge_request

# Use:
#       glmm
#       $1-PROJECT_NAME
#       $2-MR_ID
#       ($3-rm)
