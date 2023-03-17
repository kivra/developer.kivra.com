# API documentation

This repository contains an OpenAPI 3 specification of the Kivra API.
An interactive version of the documentation is hosted on https://developer.kivra.com

Note: The interactivity and presentation is all done in JS in the browser. This means
the YAML is served as is from the source. There is no transformation of the file, so
e.g. any comments are included.

## Deployment

This project is deployed automatically when a commit is pushed to `master`.
The deploy is done by Cloud Build: https://console.cloud.google.com/cloud-build/dashboard

## Developing

```shell
$ docker-compose up
```

The site is hosted locally at `http://localhost:3080`.

Now you can edit the `swagger.yaml` and just refresh the browser to see your changes.
