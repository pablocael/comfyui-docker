#!/bin/bash

set -eox pipefail

echo "Using CIVITAI Token: ${CIVITAI_TOKEN:0:4}****"

function download_models_from_file () {
    if [ ! -f "$1" ]; then
        echo "[ERROR] File not found: $1"
        return 1
    fi
    cd /root/ComfyUI
    aria2c -d . --max-concurrent-downloads=4 -c --auto-file-renaming=false --allow-overwrite=false --input-file=$1
}

echo "Using CIVITAI Token: ${CIVITAI_TOKEN:0:4}****"

if  [[ SKIP_MODEL_DOWNLOAD -eq "1"  ]]; then
    echo "Skipping model download ..."
else
    echo "########################################"
    echo "[INFO] Downloading Models"
    echo "########################################"
    # Downloading models
    if [[ USE_WAN_MODELS -eq "1"  ]]; then
        echo "########################################"
        echo "Downloading WAN models ..."
        echo "########################################"
        CIVITAI_TOKEN=$CIVITAI_TOKEN envsubst < /model_files/wan.txt > /model_files/wan_expanded.txt
        download_models_from_file /model_files/wan_expanded.txt
    fi

    if [[ USE_HUNYUAN_MODELS -eq "1"  ]]; then
        echo "Downloading HV models ..."
        CIVITAI_TOKEN=$CIVITAI_TOKEN envsubst < /model_files/hv.txt > /model_files/hv_expanded.txt
        download_models_from_file /model_files/hv_expanded.txt
    fi

    if [[ USE_SDXL_MODELS -eq "1"  ]]; then
        echo "########################################"
        echo "Downloading SDXL models ..."
        echo "########################################"
        CIVITAI_TOKEN=$CIVITAI_TOKEN envsubst < /model_files/sdxl.txt > /model_files/sdxl_expanded.txt
        download_models_from_file /model_files/sdxl_expanded.txt
    fi

    if [[ USE_QWEN_MODELS -eq "1"  ]]; then
        echo "########################################"
        echo "Downloading QWEN models ..."
        echo "########################################"
        CIVITAI_TOKEN=$CIVITAI_TOKEN envsubst < /model_files/qwen.txt > /model_files/qwen_expanded.txt
        download_models_from_file /model_files/qwen_expanded.txt
    fi

    echo "########################################"
    echo "Downloading UPSCALE models ..."
    echo "########################################"
    CIVITAI_TOKEN=$CIVITAI_TOKEN envsubst < /model_files/upscale.txt > /model_files/upscale_expanded.txt
    download_models_from_file /model_files/upscale_expanded.txt
    # Finish
    touch /root/.download-complete
fi

echo "All done."


