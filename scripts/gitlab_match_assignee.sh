#!/bin/sh

case $1 in
"laurent") ASSIGNEE_ID=" --assignee-id 1" ;;
"vincent") ASSIGNEE_ID=" --assignee-id 2" ;;
"julian") ASSIGNEE_ID=" --assignee-id 8" ;;
*) ASSIGNEE_ID="" ;;
esac

echo $ASSIGNEE_ID;
