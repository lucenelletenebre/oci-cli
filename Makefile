ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

DOCKER_IMAGE=oci-cli-slim
DOCKER_IMAGE_PROD=ghcr.io/lucenelletenebre/oci-cli-slim

.PHONY: lint build clean get-size run run2 run-deploy

make.env:
	if [ ! -f "make.env" ]; then \
    	echo "CREATE ENVIROMENT file";\
		touch make.env; \
	fi

include make.env

lint: 
	clear
	docker run --rm \
	-e RUN_LOCAL=true \
	-v $(ROOT_DIR):/tmp/lint \
	github/super-linter:slim-v4

lint-docker: 
	clear
	docker run --rm \
	-e RUN_LOCAL=true \
	-e VALIDATE_DOCKERFILE_HADOLINT=true \
	-v $(ROOT_DIR):/tmp/lint \
	github/super-linter:slim-v4

clean:
	docker rmi $(DOCKER_IMAGE)
	docker rmi $(DOCKER_IMAGE_PROD)
	docker builder prune --all --force

build:
	docker build \
	-t $(DOCKER_IMAGE) \
	.

get-size: build
	docker save $(DOCKER_IMAGE) -o $(DOCKER_IMAGE).tar
	gzip $(DOCKER_IMAGE).tar
	ls -lh $(DOCKER_IMAGE).tar.gz
	rm $(DOCKER_IMAGE).tar.gz

run2: build
	docker run --rm -it \
	-v $(ROOT_DIR)/my_keys:/config \
	--env-file make.env \
	$(DOCKER_IMAGE) \
	compute instance get --instance-id=${INSTANCE_ID}

run: build
	docker run --rm -it \
	-v $(ROOT_DIR)/my_keys:/config \
	--env-file make.env \
	$(DOCKER_IMAGE) \
	compute instance list --compartment-id=${OCI_CLI_TENANCY}
	
run-deploy:
	docker pull $(DOCKER_IMAGE_PROD)
	docker run --rm -it \
	-v $(ROOT_DIR)/my_keys:/config \
	--env-file make.env \
	$(DOCKER_IMAGE_PROD) \
	compute instance list --compartment-id=${OCI_CLI_TENANCY}