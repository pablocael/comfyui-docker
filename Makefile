
prepare:
	rsync -r --progress ~/Dropbox/Files/ComfyUI/models ./models/

cleanup:
	rm -rf models

sdxl: prepare
	@echo "Building SDXL container..."
	docker build --build-arg use_sdxl_models=true -t pablocael/comfyui-sdxl:latest -f Dockerfile .
	cleanup

swan: prepare
	@echo "Building WAN container..."
	docker build --build-arg use_wan_models=true -t pablocael/comfyui-wan:latest -f Dockerfile .
	cleanup

sdxl-wan: prepare
	@echo "Building SDXL WAN container..."
	docker build --build-arg use_sdxl_models=true --build-arg use_wan_models=true -t pablocael/comfyui-sdxl-wan:latest -f Dockerfile .
	cleanup

hv: prepare
	@echo "Building HUNYUAN container..."
	docker build --build-arg use_hv_models=true -t pablocael/comfyui-hunyuan:latest -f Dockerfile .
	cleanup

flux: prepare
	@echo "Building FLUX container..."
	docker build --build-arg use_flux_models=true -t pablocael/comfyui-flux:latest -f Dockerfile .
	cleanup


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
