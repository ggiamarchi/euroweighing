#!/bin/bash

# This script deploys the application to GitHub Pages.
# This script suppose files to deploy are in the dist folder.
# It copies the files to the root directory and updates the paths in index.html.
# Usage: ./deploy.sh
# Make sure to run this script from the root of the repository.
# Ensure you have the correct permissions to run this script
# and that you have the necessary git configuration set up.
# Ensure you have the correct branch checked out (usually gh-pages or main)
# Ensure you have the dist folder ready with the built application files

set -e

cp -rf dist/* .

cat index.html | sed -e "s/\/assets/\/euroweighing\/assets/g" > index.html.new
mv index.html.new index.html

git add index.html assets favicon.ico
git commit -m "Deploy to GitHub Pages"

git push

