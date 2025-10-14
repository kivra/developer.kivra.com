# API documentation

This repository contains an OpenAPI 3 specification of the Kivra API.
An interactive version of the documentation is hosted on https://developer.kivra.com.

Note: The interactivity and presentation is all done in JS in the browser. This means
the YAML is served as is from the source. There is no transformation of the file, so
e.g. any comments are included.

## Deployment

This project is deployed automatically by Clould Build when a commit is pushed to `master`.

The Trigger can be found [here](https://console.cloud.google.com/cloud-build/triggers;region=global/edit/98e58035-8ed7-4b24-bb60-08ae3b269ffc?project=apt-aleph-767) and triggered builds can be found [here](https://console.cloud.google.com/cloud-build/builds;region=global?query=trigger_id%3D%2298e58035-8ed7-4b24-bb60-08ae3b269ffc%22&project=apt-aleph-767).

## Developing

```shell
$ docker-compose up
```

The site is hosted locally at `http://localhost:3080`.

Now you can edit the `swagger.yaml` and just refresh the browser to see your changes.
