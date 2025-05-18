#!/bin/bash

cd /root/ComfyUI/models

echo "Downloading Hunyuan I2V Video Models..."
mkdir -p /root/ComfyUI/models/diffusion_models/HV/I2V
cd /root/ComfyUI/models/diffusion_models/HV/I2V
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_I2V_720_fixed_fp8_e4m3fn.safetensors
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/FramePackI2V_HY_bf16.safetensors
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/FramePackI2V_HY_fp8_e4m3fn.safetensors

echo "Downloading Hunyuan T2V Video Models..."
mkdir -p /root/ComfyUI/models/diffusion_models/HV/T2V
cd /root/ComfyUI/models/diffusion_models/HV/T2V
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/6e02d99d3e62501ed5533cd7e174153012cf18c0/hunyuan_video_720_fp8_e4m3fn.safetensors
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_720_cfgdistill_fp8_e4m3fn.safetensors
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_720_cfgdistill_bf16.safetensors

echo "Downloading Hunyuan VAEs ..."
mkdir /root/ComfyUI/models/vae/HV/
cd /root/ComfyUI/models/vae/HV/
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_vae_bf16.safetensors 
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_vae_fp32.safetensors


echo "Downloading clip models ..."
cd /root/ComfyUI/models/clip/
wget https://huggingface.co/calcuis/hunyuan-gguf/resolve/main/llava_llama3_fp8_scaled.safetensors
wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors

echo "Downloading SDXL models ..."
mkdir /root/ComfyUI/models/checkpoints/SDXL/
cd /root/ComfyUI/models/checkpoints/SDXL/
wget -O pornmaster_asianSdxlV1VAE.safetensors "https://civitai.com/api/download/models/1526663?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=$CIVITAI_TOKEN"
