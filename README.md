# API documentation

This repository contains an OpenAPI 3 specification of the Kivra API.
An interactive version of the documentation is hosted on https://developer.kivra.com

## Development

Run:
```
docker-compose up
```
Then head to http://localhost:8080 with your browser.
Changes to the docs will be automatically visible when you refresh the browser.

## Deployment

The project is running in GCP Cloud Run and is deployed automatically by
GCP Cloud Build (see `cloudbuild.yaml`) when a commit is pushed to `master`.
