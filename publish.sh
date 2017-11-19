#!/bin/sh
# Publish the site from docs to GitHub

set -e

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"
REPO=$(git config remote.origin.url)
SHA=`git rev-parse --verify HEAD`

# Clone the existing gh-pages for this repo into a second working repository
# in the web/ directory.
# Create a new empty branch if gh-pages doesn't exist yet
# (should only happen on first deploy)
rm -rf web
git clone $REPO web
cd web
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH

# Clean web existing contents
rm -rf *

# Build and bring in current content
(cd .. && ./mkall.sh )
cp ../v4man.pdf .
cp ../site-index.html index.html

if git diff --quiet ; then
  echo "No changes to the output on this push; exiting."
  exit 0
fi

git add --all .
git commit -m "Deploy to GitHub Pages: ${SHA}"
git push
