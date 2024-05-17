# Hello, Betterplace

test app

# Copy containers from container registry to artifact registry

## Staging europe-docker.pkg.dev/staging-env-182516/eu.gcr.io

europe-west1-docker.pkg.dev/staging-env-182516/public

# Copy image from between registries

Below the command to copy a specific image from staging artifact registry to production artifact registry

```
gcrane cp eu.gcr.io/staging-env-182516/hello:c8d3880  europe-docker.pkg.dev/betterplace-183212/eu.gcr.io/hello:c8d3880
```