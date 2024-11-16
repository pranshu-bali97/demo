#!/bin/bash

URL=$1
DAYS=$2
#Get the repository name from the URL
REPO_NAME=$(basename -s .git "$URL")
#Get the repository path 
REPO_PATH="/home/ubuntu204/$REPO_NAME"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repo-url> <days>"
    echo "Example: $0 https://github.com/user/repo.git 15"
    exit 1
fi

#Change to the repo directory
cd "$REPO_PATH" || { echo "$REPO_PATH NOT FOUND :("; exit 1; }

#Creating a Report file
touch Commit_report.csv

# Generating the Report file
git log --since="$DAYS days ago" --pretty=format:"|%H, %an, %ae, %s," --name-only > Commit_report.csv

echo "Report file created at ${REPO_PATH}/Commit_report.csv"
