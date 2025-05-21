#!/bin/bash

cd /root/ComfyUI/models

download_if_missing() {
    local url="$1"
    local filename="${2:-$(basename "$url")}"
    if [[ ! -f "$filename" ]]; then
        echo "Downloading $filename ..."
        wget -O "$filename" "$url"
    else
        echo "File $filename already exists. Skipping download."
    fi
}

if [[ -v USE_HUNYUAN_MODELS ]]; then
    echo "Downloading Hunyuan I2V Video Models..."
    mkdir -p /root/ComfyUI/models/diffusion_models/HV/I2V
    cd /root/ComfyUI/models/diffusion_models/HV/I2V
    download_if_missing "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_I2V_720_fixed_fp8_e4m3fn.safetensors"
    download_if_missing "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/FramePackI2V_HY_bf16.safetensors"
    download_if_missing "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/FramePackI2V_HY_fp8_e4m3fn.safetensors"

    echo "Downloading Hunyuan T2V Video Models..."
    mkdir -p /root/ComfyUI/models/diffusion_models/HV/T2V
    cd /root/ComfyUI/models/diffusion_models/HV/T2V
    download_if_missing "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/6e02d99d3e62501ed5533cd7e174153012cf18c0/hunyuan_video_720_fp8_e4m3fn.safetensors"
    download_if_missing "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_720_cfgdistill_fp8_e4m3fn.safetensors"
    download_if_missing "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_720_cfgdistill_bf16.safetensors"

    echo "Downloading Hunyuan VAEs ..."
    mkdir -p /root/ComfyUI/models/vae/HV/
    cd /root/ComfyUI/models/vae/HV/
    download_if_missing "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_vae_bf16.safetensors"
    download_if_missing "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_vae_fp32.safetensors"

    echo "Copying Hunyuan Loras ..."
    ls -lah /root/
    cp -Rf /models/loras/* /root/ComfyUI/models/loras/
fi

if [[ -v USE_WAN_MODELS ]]; then
    echo "Downloading WAN T2V Video Models..."
    mkdir -p /root/ComfyUI/models/diffusion_models/WAN/T2V
    cd /root/ComfyUI/models/diffusion_models/WAN/T2V
    download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-T2V-14B_CausVid_fp8_e4m3fn.safetensors"

    echo "Downloading WAN I2V Video Models..."
    mkdir -p /root/ComfyUI/models/diffusion_models/WAN/I2V
    cd /root/ComfyUI/models/diffusion_models/WAN/I2V
    download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-T2V-14B_fp8_e4m3fn.safetensors"

    echo "Downloading WAN VAEs ..."
    mkdir -p /root/ComfyUI/models/vae/WAN/
    cd /root/ComfyUI/models/vae/WAN/
    download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_fp32.safetensors"

    echo "Copying WAN Loras ..."
    cp -Rf /models/loras/WAN/ /root/ComfyUI/models/loras/
fi

if [[ -v USE_SDXL_MODELS ]]; then
    echo "Downloading SDXL models ..."
    mkdir -p /root/ComfyUI/models/checkpoints/SDXL/
    cd /root/ComfyUI/models/checkpoints/SDXL/
    download_if_missing "https://civitai.com/api/download/models/1526663?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=$CIVITAI_TOKEN" "pornmaster_asianSdxlV1VAE.safetensors"

    echo "Copying SDXL Loras ..."
    cp -Rf /models/loras/SDXL/ /root/ComfyUI/models/loras/
fi

echo "Downloading common clip models ..."
cd /root/ComfyUI/models/clip/
download_if_missing "https://huggingface.co/calcuis/hunyuan-gguf/resolve/main/llava_llama3_fp8_scaled.safetensors"
download_if_missing "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-fp8_e4m3fn.safetensors"
download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors"
