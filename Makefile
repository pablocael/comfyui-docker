
base:
	@echo "Building BASE container..."
	docker build --secret id=publickey,src=${HOME}/.ssh/id_ed25519.pub -t pablocael/comfyui-base:latest -f Dockerfile.base .
	$(cleanup)

cleanup:
	echo "Cleaning ..."

build: base
	export DOCKER_BUILDKIT=1
	docker build -t pablocael/comfyui:latest -f Dockerfile .
	$(cleanup)


# push container based on name passed by argument
# usage: make push name=container_name
.PHONY push:
push:
	docker push pablocael/comfyui:latest

run:	
	docker run --rm -it -v /mnt/data-server/comfy-models/:/root/ComfyUI/models/ -p 8188:8188 -e CIVITAI_TOKEN=b3dda7cccbaac1dca0ac903c5279ec0a --gpus all --name comfyui pablocael/comfyui:latest
