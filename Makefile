
base:
	@echo "Building BASE container..."
	docker build -t pablocael/comfyui-base-12.9:latest -f Dockerfile.12.9.base .
	$(cleanup)

cleanup:
	echo "Cleaning ..."

build: base
	@echo "Building QWEN SDXL WAN container..."
	docker build -t pablocael/comfyui:latest -f Dockerfile .
	$(cleanup)


# push container based on name passed by argument
# usage: make push name=container_name
.PHONY push:
push:
	docker push pablocael/comfyui:latest

run:
	docker run --rm -it -d -v ${HOME}/comfyui-docker/storage:/root/ -p 8188:8188 -e CIVITAI_TOKEN=b3dda7cccbaac1dca0ac903c5279ec0a -e CLI_ARGS=" --disable-smart-memory --disable-auto-launch --port 8188 --enable-cors-header" --name comfyui pablocael/comfyui:latest
