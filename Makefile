
prepare:
	echo "Preparing build context..."

cleanup:
	echo "Cleaning ..."

sdxl: prepare
	@echo "Building SDXL container..."
	docker build --build-context models_path=${HOME}/Dropbox/Files/ComfyUI -t pablocael/comfyui-sdxl:latest -f Dockerfile.sdxl .
	$(cleanup)

wan: prepare
	@echo "Building WAN container..."
	docker build --build-arg use_wan_models=true --build-context models_path=${HOME}/Dropbox//Files/ComfyUI -t pablocael/comfyui-wan:latest -f Dockerfile.wan .
	$(cleanup)

sdxl-wan: prepare
	@echo "Building SDXL WAN container..."
	docker build --build-context models_path=${HOME}/Dropbox/Files/ComfyUI -t pablocael/comfyui-sdxl-wan:latest -f Dockerfile.sdxlwan .
	$(cleanup)

hv: prepare
	@echo "Building HUNYUAN container..."
	docker build --build-context models_path=${HOME}/Dropbox/Files/ComfyUI -t pablocael/comfyui-hunyuan:latest -f Dockerfile.hv .
	$(cleanup)

flux: prepare
	@echo "Building FLUX container..."
	docker build --build-arg --build-context models_path=${HOME}/Dropbox/Files/ComfyUI -t pablocael/comfyui-flux:latest -f Dockerfile.flux .
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
