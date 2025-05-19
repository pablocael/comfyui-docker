FROM nvidia/cuda:12.8.0-runtime-ubuntu22.04
SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y unzip curl openssh-server wget git build-essential cmake aria2 ffmpeg libgl1 python3-venv 
RUN apt-get install -y python3-pip


RUN pip3 install --upgrade pip
RUN pip3 install pyyaml

COPY runner-scripts/.  /runner-scripts/
COPY entrypoint.sh /entrypoint.sh

USER root
VOLUME /root
WORKDIR /root

RUN python3 -m venv ./python-env
RUN source ./python-env/bin/activate
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/entrypoint.sh"]
