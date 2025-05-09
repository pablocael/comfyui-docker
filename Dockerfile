FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

RUN apt update && apt install -y unzip curl openssh-server wget git build-essential cmake aria2 ffmpeg libgl1
RUN apt-get install -y python3-pip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN pip3 install --upgrade pip

COPY runner-scripts/.  /runner-scripts/
COPY entrypoint.sh /entrypoint.sh

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/entrypoint.sh"]
