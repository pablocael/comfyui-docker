# ----- Base stage -----
FROM nvidia/cuda:12.8.0-runtime-ubuntu22.04 AS base
SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y unzip curl openssh-server wget git build-essential cmake aria2 ffmpeg libgl1 python3-venv 
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install pyyaml

COPY runner-scripts/.  /runner-scripts/
COPY entrypoint.sh /entrypoint.sh

# ----- Model data stages -----
FROM scratch AS hv_models
COPY ./models/loras/HV/ /models/HV/

FROM scratch AS wan_models
COPY ./models/loras/WAN/ /models/WAN/

FROM scratch AS sdxl_models
COPY ./models/loras/SDXL/ /models/SDXL/

# ----- Final stage -----
FROM base AS final

ARG use_hv_models=false
ARG use_wan_models=false
ARG use_sdxl_models=false

# Copy HV if needed
COPY --from=hv_models /models/HV/ /models/loras/HV/
RUN if [ "$use_hv_models" != "true" ]; then rm -rf /models/loras/HV; fi

# Copy WAN if needed
COPY --from=wan_models /models/WAN/ /models/loras/WAN/
RUN if [ "$use_wan_models" != "true" ]; then rm -rf /models/loras/WAN; fi

# Copy SDXL if needed
COPY --from=sdxl_models /models/SDXL/ /models/loras/SDXL/
RUN if [ "$use_sdxl_models" != "true" ]; then rm -rf /models/loras/SDXL; fi

ENV USE_SDXL_MODELS=$use_sdxl_models
ENV USE_HV_MODELS=$use_hv_models
ENV USE_WAN_MODELS=$use_wan_models


# Final setup
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash", "/entrypoint.sh"]
