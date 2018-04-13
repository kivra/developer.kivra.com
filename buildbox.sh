#!/usr/bin/env bash
set -o errexit #abort if any command fails

echo '--- building'
docker build -t developerkivracom_app .
docker run --rm -v ${PWD}/source:/usr/src/app/source developerkivracom_app widdershins documentation/index.yaml -o source/index.html.md

echo '--- deploying'
GIT_DEPLOY_EMAIL=$BUILDKITE_BUILD_CREATOR_EMAIL GIT_DEPLOY_USERNAME=$BUILDKITE_BUILD_CREATOR ./deploy.sh
