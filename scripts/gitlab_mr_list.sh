#!/bin/sh

PROJECT_ID=`$SCRIPT_PATH/gitlab_match_project.sh $1`

function _merge_request() { gitlab project-merge-request list --project-id $PROJECT_ID; };
_merge_request

# Erroneous API return
# Use:
#       glmrl
#       $1-PROJECT_NAME
