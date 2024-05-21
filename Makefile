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

setup: fake-package fetch

fake-package:
	rm -rf $(GOPATH)/src/github.com/betterplace/betterplace-hello
	mkdir -p $(GOPATH)/src/github.com/betterplace
	ln -s $(shell pwd) $(GOPATH)/src/github.com/betterplace/betterplace-hello

clean:
	@rm -f hello tags

clobber: clean
	@rm -rf $(GOPATH)/*

tags: clean
	@gotags -tag-relative=false -silent=true -R=true -f $@ . $(GOPATH)

build-info:
	@echo $(REMOTE_TAG)
	@docker inspect $(DOCKER_IMAGE) | grep -i 'created'

build:
	docker build --pull -t $(DOCKER_IMAGE) -t $(DOCKER_IMAGE_LATEST)  --build-arg REVISION=$(REVISION_SHORT) .
	$(MAKE) build-info

build-force:
	docker build --pull -t $(DOCKER_IMAGE) -t $(DOCKER_IMAGE_LATEST) --no-cache  --build-arg REVISION=$(REVISION_SHORT) .
	$(MAKE) build-info

server: build
	docker run -it -e PORT=$(DOCKER_PORT) -p $(DOCKER_PORT):$(DOCKER_PORT) $(DOCKER_IMAGE)

push: build
	docker tag $(DOCKER_IMAGE) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

push-latest: push
	docker tag ${DOCKER_IMAGE} ${REMOTE_LATEST_TAG}
	docker push ${REMOTE_LATEST_TAG}
