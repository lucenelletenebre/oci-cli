ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

DOCKER_IMAGE=oci-cli-slim

.PHONY: build clean run run2

make.env:
	if [ ! -f "make.env" ]; then \
    	echo "CREATE ENVIROMENT file";\
		touch make.env; \
	fi

include make.env

clean:
	docker rmi $(DOCKER_IMAGE)
	docker builder prune --all --force

build:
	docker build \
	-t $(DOCKER_IMAGE) \
	.

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
	-v
	
# --entrypoint=/bin/ash \