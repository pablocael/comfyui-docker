#!/bin/bash

set -euox pipefail

function download_models_from_file () {
    if [ ! -f "$1" ]; then
        echo "[ERROR] File not found: $1"
        return 1
    fi
    cd /root/ComfyUI
    aria2c -d . --max-concurrent-downloads=4 -c --auto-file-renaming=false --allow-overwrite=false --input-file=$1
}

if  [[ -v SKIP_MODEL_DOWNLOAD ]]; then
    echo "Skipping model download ..."
else
    echo "########################################"
    echo "[INFO] Downloading Models"
    echo "########################################"
    # Downloading models
    if [[ -v USE_WAN_MODELS ]]; then
        echo "Downloading WAN models ..."
        download_models_from_file /model_files/wan.txt 
    fi

    if [[ -v USE_HUNYUAN_MODELS ]]; then
        echo "Downloading HV models ..."
        download_models_from_file /model_files/hv.txt
    fi

    if [[ -v USE_SDXL_MODELS ]]; then
        echo "Downloading SDXL models ..."
        download_models_from_file /model_files/sdxl.txt
    fi

    if [[ -v USE_QWEN_MODELS ]]; then
        echo "Downloading QWEN models ..."
        download_models_from_file /model_files/qwen.txt
    fi

    echo "Downloading upscale models ..."
    download_models_from_file /model_files/upscale.txt
    # Finish
    touch /root/.download-complete
fi

echo "All done."


