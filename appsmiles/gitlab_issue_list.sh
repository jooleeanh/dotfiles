#!/bin/sh

PROJECT_ID=`$APM_SCRIPT_PATH/gitlab_match_project.sh $1`

function _issue_list() { gitlab project-issue list --project-id $PROJECT_ID ;};
_issue_list;

## Use:
##       glil
##       $1-PROJECT_NAME
