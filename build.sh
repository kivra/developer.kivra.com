#!/usr/bin/env bash
set -o errexit #abort if any command fails

docker build .
