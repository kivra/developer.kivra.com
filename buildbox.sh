#!/usr/bin/env bash
set -o errexit #abort if any command fails

echo '--- building'
docker build -t developerkivracom_app .

echo '--- deploying'
./deploy.sh
