#!/usr/bin/env bash
set -o errexit #abort if any command fails

echo '--- building'
docker build .

echo '--- deploying'
./deploy.sh
