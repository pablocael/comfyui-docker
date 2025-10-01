
base:
	@echo "Building BASE container..."
	docker build -t pablocael/comfyui-base-13.1:latest -f Dockerfile.13.1.base .
	$(cleanup)

cleanup:
	echo "Cleaning ..."

qsw: base
	@echo "Building QWEN SDXL WAN container..."
	docker build -t pablocael/comfyui-qsw:latest -f Dockerfile.qwensdxlwan .
	$(cleanup)

wan: base
	@echo "Building WAN container..."
	docker build -t pablocael/comfyui-wan:latest -f Dockerfile.wan .
	$(cleanup)

# push container based on name passed by argument
# usage: make push name=container_name
.PHONY push:
push:
	@echo "Pushing container $${name}..."
	docker push pablocael/comfyui-$${name}:latest
	@echo "Pushing container $${name}-latest..."
	docker tag pablocael/comfyui-$${name}:latest pablocael/comfyui-$${name}:latest
	docker push pablocael/comfyui-$${name}:latest
	@echo "Pushed container $${name}."

run:
	docker run --rm -it -d -v ${HOME}/comfyui-docker/storage:/root/ -p 8188:8188 -e CIVITAI_TOKEN=b3dda7cccbaac1dca0ac903c5279ec0a -e CLI_ARGS=" --disable-smart-memory --disable-auto-launch --port 8188 --enable-cors-header" --gpus all --name comfyui pablocael/comfyui-$${name}:latest
