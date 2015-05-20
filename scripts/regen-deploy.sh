#!/bin/bash

HUGODIR=.
SLEEP=300
FIRST=yes
SEARCHOPTS="--notebook cf-learn.info --tag published --remove-tags"
HUGOOPTS="-o $HUGODIR"
ADDOPTS="$@"
DEPLOY=$(dirname $0)/deploy.sh

while true
do
    echo `date` Running Enwrite...
    enwrite $SEARCHOPTS $HUGOOPTS $ADDOPTS $FIRSTOPTS

    # Regenerate and deploy on the first pass through the loop or when content changes
    if [[ $? -eq 0 || "$FIRST" == "yes" ]]
    then
        (cd "$HUGODIR";
         echo `date` Checking into github the changes made by Enwrite
         git add content static; git ci -a -m "Content generated by Enwrite on $(date)"; git push;
         echo `date` Regenerating site with Hugo
         hugo;
         echo `date` Deploying Hugo site to github
         $DEPLOY)
    fi
    FIRSTOPTS=""
    FIRST=no
    echo `date` "Sleeping for $SLEEP seconds..."; sleep $SLEEP
done
