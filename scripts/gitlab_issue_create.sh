#!/bin/sh

PROJECT_ID=`$SCRIPT_PATH/gitlab_match_project.sh $1`
TITLE="$2"
DESC_TAG=""

if [ $# -ge 3 ]
    then
        DESC_TAG="--description"
        DESCRIPTION="$3"
fi

if [ $# -ge 4 ]
    then
        ASSIGNEE_ID=`$SCRIPT_PATH/gitlab_match_assignee.sh $4`
fi

function _issue_create() { gitlab project-issue create --project-id $PROJECT_ID --title "$TITLE" $DESC_TAG "$DESCRIPTION" $ASSIGNEE_ID ;};
_issue_create;

# Use:
#       glic
#       $1-PROJECT_NAME
#       $2-TITLE
#       ($3-DESCRIPTION)
#       ($4-ASSIGNEE_NAME)
