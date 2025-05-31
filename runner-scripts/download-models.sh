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


echo "Enabled model flags: $USE_HUNYUAN_MODELS=$USE_HUNYUAN_MODELS, USE_WAN_MODELS=$USE_WAN_MODELS, USE_SDXL_MODELS=$USE_SDXL_MODELS, USE_FLUX_MODELS=$USE_FLUX_MODELS"

if [ "$USE_HUNYUAN_MODELS" == "true" ]; then
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

if [ "$USE_WAN_MODELS" == "true" ]; then
    echo "Downloading WAN T2V Video Models..."
    mkdir -p /root/ComfyUI/models/diffusion_models/WAN/T2V
    cd /root/ComfyUI/models/diffusion_models/WAN/T2V
    download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-T2V-14B_CausVid_fp8_e4m3fn.safetensors"
    download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-T2V-14B_fp8_e4m3fn.safetensors"

    echo "Downloading WAN T2V Video Models..."
    mkdir -p /root/ComfyUI/models/diffusion_models/WAN/T2V
    cd /root/ComfyUI/models/diffusion_models/WAN/T2V

    echo "Downloading WAN I2V Video Models..."
    mkdir -p /root/ComfyUI/models/diffusion_models/WAN/I2V
    cd /root/ComfyUI/models/diffusion_models/WAN/I2V
    download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-VACE_module_14B_fp8_e4m3fn.safetensors" 
    download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors"

    mkdir -p /root/ComfyUI/models/unet/WAN/I2V
    cd /root/ComfyUI/models/unet/WAN/I2V
    download_if_missing "https://huggingface.co/city96/Wan2.1-I2V-14B-480P-gguf/resolve/main/wan2.1-i2v-14b-480p-Q6_K.gguf"

    echo "Downloading WAN VAEs ..."
    mkdir -p /root/ComfyUI/models/vae/WAN/
    cd /root/ComfyUI/models/vae/WAN/
    download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_fp32.safetensors"

    echo "Copying WAN Loras ..."
    cp -Rf /models/loras/WAN/ /root/ComfyUI/models/loras/
fi

if [ "$USE_SDXL_MODELS" == "true" ]; then
    echo "Downloading SDXL models ..."
    mkdir -p /root/ComfyUI/models/checkpoints/SDXL/
    cd /root/ComfyUI/models/checkpoints/SDXL/
    download_if_missing "https://civitai.com/api/download/models/1526663?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=$CIVITAI_TOKEN" "pornmaster_asianSdxlV1VAE.safetensors"
    download_if_missint "https://civitai.com/api/download/models/1678726?type=Model&format=SafeTensor&size=full&fp=fp32&token=$CIVITAI_TOKEN" "pornmaster_proSDXLV4VAE.safetensors"
    download_if_missing "https://civitai.com/api/download/models/1308957?type=Model&format=SafeTensor&size=full&fp=fp32&token=$CIVITAI_TOKEN" "pornmaster_proSDXLV3VAE.safetensors"
    download_if_missing "https://civitai.com/api/download/models/1081768?type=Model&format=SafeTensor&size=full&fp=fp16&token=$CIVITAI_TOKEN" "bigLust_v16.safetensors"
    download_if_missing "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"

    echo "Copying SDXL Loras ..."
    cp -Rf /models/loras/SDXL/ /root/ComfyUI/models/loras/
fi

if [ "$USE_FLUX_MODELS" == "true" ]; then
    echo "Downloading FLUX models ..."
    mkdir -p /root/ComfyUI/models/checkpoints/FLUX/
    cd /root/ComfyUI/models/checkpoints/FLUX/
    download_if_missing "https://huggingface.co/XLabs-AI/flux-dev-fp8/resolve/main/flux-dev-fp8.safetensors"

    echo "Copying FLUX Loras ..."
    cp -Rf /models/loras/FLUX/ /root/ComfyUI/models/loras/
fi


echo "Downloading common clip models ..."
cd /root/ComfyUI/models/clip/
download_if_missing "https://huggingface.co/calcuis/hunyuan-gguf/resolve/main/llava_llama3_fp8_scaled.safetensors"
download_if_missing "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-fp8_e4m3fn.safetensors"
download_if_missing "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors"
download_if_missing "https://huggingface.co/city96/umt5-xxl-encoder-gguf/resolve/main/umt5-xxl-encoder-Q6_K.gguf"

cd /root/ComfyUI/models/clip_vision/
download_if_missing "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"
