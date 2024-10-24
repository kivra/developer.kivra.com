#!/bin/bash

if [[ "$1" == "master" ]]; then
    target="gs://developer.kivra.com/"
else
    target="gs://developer.kivra.com/$1/"
fi

echo "Deploying to $target"

gsutil cp index.html swagger.yml $target
gsutil cp -r assets $target
gsutil cp -r receipt $target
gsutil cp -r v1 $target
gsutil cp -r v3 $target
