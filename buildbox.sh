#!/usr/bin/env bash
set -o errexit #abort if any command fails

echo '--- building'
docker build -t developerkivracom_app .

echo '--- deploying'
GIT_DEPLOY_EMAIL=$BUILDKITE_BUILD_CREATOR_EMAIL GIT_DEPLOY_USERNAME=$BUILDKITE_BUILD_CREATOR ./deploy.sh
