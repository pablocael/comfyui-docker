FROM pablocael/comfyui-base:latest
SHELL ["/bin/bash", "-c"]

COPY runner-scripts/.  /runner-scripts/
COPY entrypoint.sh /entrypoint.sh
COPY model_files/ /model_files/

ENV USE_SDXL_MODELS="true"
ENV USE_WAN_MODELS="true"
ENV USE_QWEN_MODELS="true"

LABEL vast.ai.service.comfyui.port=8188
LABEL vast.ai.service.comfyui.name="ComfyUI"
LABEL vast.ai.service.comfyui.path="/"

# final setup
VOLUME /root
WORKDIR /root
EXPOSE 8188 122
ENV CLI_ARGS=""
ENV CIVITAI_TOKEN=""

CMD ["bash", "/entrypoint.sh"]
