# Global variable
# Docker Hub username
DOCKERHUB_USERNAME := pablocael
PUBLIC_KEY_PATH := ${HOME}/.ssh/id_ed25519.pub

base:
	@echo "Building BASE container..."
	docker build --secret id=publickey,src=${PUBLIC_KEY_PATH} -t ${DOCKERHUB_USERNAME}/comfyui-base:latest -f Dockerfile.base .
	$(cleanup)

cleanup:
	echo "Cleaning ..."

build: base
	export DOCKER_BUILDKIT=1
	docker build -t ${DOCKERHUB_USERNAME}/comfyui:latest -f Dockerfile .
	$(cleanup)


# push container based on name passed by argument
# usage: make push name=container_name
.PHONY push:
push:
	docker push ${DOCKERHUB_USERNAME}/comfyui:latest

run:	
	docker run --rm -it -v /mnt/data-server/comfy-models/:/root/ComfyUI/models/ -p 8188:8188 -e CIVITAI_TOKEN=${CIVITAI_TOKEN} --gpus all --name comfyui ${DOCKERHUB_USERNAME}/comfyui:latest
