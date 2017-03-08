#!/bin/sh

PROJECT_ID=`$SCRIPT_FOLDER_PATH/gitlab_match_project.sh $1`
TITLE="$2"
DESCRIPTION="$3"

if [ $# -eq 4 ]
    then
        ASSIGNEE_ID=`$SCRIPT_FOLDER_PATH/gitlab_match_assignee.sh $4`
fi

function _issue_create() { gitlab project-issue create --project-id $PROJECT_ID --title "$TITLE" --description "$DESCRIPTION" $ASSIGNEE_ID ;};
_issue_create;

# Use:
#       glic
#       $1-PROJECT_NAME
#       $2-TITLE
#       $3-DESCRIPTION
#       $4-ASSIGNEE_NAME
