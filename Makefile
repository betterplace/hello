DOCKER_IMAGE_LATEST = hello
DOCKER_IMAGE = $(DOCKER_IMAGE_LATEST):$(REVISION_SHORT)
PROJECT_ID = betterplace-183212
DOCKER_PORT ?= 8080
REMOTE_LATEST_TAG := eu.gcr.io/${PROJECT_ID}/$(DOCKER_IMAGE_LATEST)
REMOTE_TAG = eu.gcr.io/$(PROJECT_ID)/$(DOCKER_IMAGE)
REVISION := $(shell git rev-parse HEAD)
REVISION_SHORT := $(shell echo $(REVISION) | head -c 7)
GOPATH := $(shell pwd)/gospace
GOBIN = $(GOPATH)/bin

.EXPORT_ALL_VARIABLES:

all: hello

hello: cmd/hello/main.go *.go
	go build -o $@ $<

local: hello
	./hello

fetch:
	go mod download

setup: fetch

clean:
	@rm -f hello tags

clobber: clean
	@rm -rf $(GOPATH)/*

tags: clean
	@gotags -tag-relative=false -silent=true -R=true -f $@ . $(GOPATH)

build-info:
	@echo $(REMOTE_TAG)

build:
	docker build --pull -t $(DOCKER_IMAGE) -t $(DOCKER_IMAGE_LATEST) .
	$(MAKE) build-info

server: build
	docker run -it -e PORT=$(DOCKER_PORT) -p $(DOCKER_PORT):$(DOCKER_PORT) $(DOCKER_IMAGE)

push: build
	gcloud auth configure-docker
	docker tag $(DOCKER_IMAGE) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

push-latest: push
	docker tag ${DOCKER_IMAGE} ${REMOTE_LATEST_TAG}
	docker push ${REMOTE_LATEST_TAG}

grype:
	@docker pull "$(REMOTE_LATEST_TAG)"
	@docker run --pull always --rm --volume /var/run/docker.sock:/var/run/docker.sock --name Grype anchore/grype:latest --add-cpes-if-none --by-cve  --fail-on low "$(REMOTE_LATEST_TAG)"
