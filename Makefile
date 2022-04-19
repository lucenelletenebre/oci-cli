ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: build run

build:
	docker build \
	-t oci-cli-slim \
	.

run: build
	docker run --rm -it \
	-v $(ROOT_DIR)/my_keys:/config \
	-v $(ROOT_DIR)/compile.py:/app/compile.py \
	--env-file .env \
	oci-cli-slim \
	compute instance get --instance-id="$$INSTANCE_ID"
