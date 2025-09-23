#!/bin/bash

set -euox pipefail

# Regex that matches REPO_NAME
# First from pattern [https://example.com/xyz/REPO_NAME.git] or [git@example.com:xyz/REPO_NAME.git]
# Second from pattern [http(s)://example.com/xyz/REPO_NAME]
# They all extract REPO_NAME to BASH_REMATCH[2]
function clone_or_pull () {
    if [[ $1 =~ ^(.*[/:])(.*)(\.git)$ ]] || [[ $1 =~ ^(http.*\/)(.*)$ ]]; then
        echo "${BASH_REMATCH[2]}" ;
        set +e ;
            git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$1" \
                || git -C "${BASH_REMATCH[2]}" pull --ff-only ;
        set -e ;
    else
        echo "[ERROR] Invalid URL: $1" ;
        return 1 ;
    fi ;
}

python3 -m venv /root/python-env
source /root/python-env/bin/activate
pip3 install --upgrade pip
pip3 install --no-cache pyyaml
pip3 install --no-cache torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu129

echo "########################################"
echo "[INFO] Downloading ComfyUI ..."
echo "########################################"

cd /root
set +e
git clone https://github.com/comfyanonymous/ComfyUI.git \
    || git -C ComfyUI pull --ff-only
set -e

echo "########################################"
echo "[INFO] Installing ComfyUI Deps..."
echo "########################################"
pip3 install -r /root/ComfyUI/requirements.txt
pip3 install -r /runner-scripts/requirements.txt

echo "########################################"
echo "[INFO] Installing ComfyUI Manager..."
echo "########################################"
cd /root/ComfyUI/custom_nodes
clone_or_pull https://github.com/ltdrdata/ComfyUI-Manager.git


echo "########################################"
echo "[INFO] Downloading Custom Nodes..."
echo "########################################"

cd /root/ComfyUI/custom_nodes

# Workspace
clone_or_pull https://github.com/crystian/ComfyUI-Crystools.git

# General
clone_or_pull https://github.com/bash-j/mikey_nodes.git
clone_or_pull https://github.com/chrisgoringe/cg-use-everywhere.git
clone_or_pull https://github.com/cubiq/ComfyUI_essentials.git
clone_or_pull https://github.com/jags111/efficiency-nodes-comfyui.git
clone_or_pull https://github.com/kijai/ComfyUI-KJNodes.git
clone_or_pull https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
clone_or_pull https://github.com/rgthree/rgthree-comfy.git
clone_or_pull https://github.com/shiimizu/ComfyUI_smZNodes.git
clone_or_pull https://github.com/WASasquatch/was-node-suite-comfyui.git
clone_or_pull https://github.com/Gourieff/ComfyUI-ReActor

# Control
clone_or_pull https://github.com/cubiq/ComfyUI_InstantID.git
clone_or_pull https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
clone_or_pull https://github.com/cubiq/PuLID_ComfyUI.git
clone_or_pull https://github.com/Fannovel16/comfyui_controlnet_aux.git
clone_or_pull https://github.com/florestefano1975/comfyui-portrait-master.git
clone_or_pull https://github.com/Gourieff/ComfyUI-ReActor.git
clone_or_pull https://github.com/huchenlei/ComfyUI-layerdiffuse.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
clone_or_pull https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
clone_or_pull https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
clone_or_pull https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
clone_or_pull https://github.com/mcmonkeyprojects/sd-dynamic-thresholding.git
clone_or_pull https://github.com/storyicon/comfyui_segment_anything.git
clone_or_pull https://github.com/twri/sdxl_prompt_styler.git

# Video
clone_or_pull https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
clone_or_pull https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
clone_or_pull https://github.com/melMass/comfy_mtb.git

# More
clone_or_pull https://github.com/cubiq/ComfyUI_FaceAnalysis.git
clone_or_pull https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
clone_or_pull https://github.com/SLAPaper/ComfyUI-Image-Selector.git
clone_or_pull https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git
clone_or_pull https://github.com/M1kep/ComfyLiterals
clone_or_pull https://github.com/Jonseed/ComfyUI-Detail-Daemon.git
clone_or_pull https://github.com/yolain/ComfyUI-Easy-Use.git
clone_or_pull https://github.com/aria1th/ComfyUI-LogicUtils.git
clone_or_pull https://github.com/ServiceStack/comfy-asset-downloader.git
clone_or_pull https://github.com/TTPlanetPig/Comfyui_TTP_Toolset.git
clone_or_pull https://github.com/shingo1228/ComfyUI-SDXL-EmptyLatentImage.git
clone_or_pull https://github.com/willmiao/ComfyUI-Lora-Manager.git
clone_or_pull https://github.com/welltop-cn/ComfyUI-TeaCache.git
clone_or_pull https://github.com/kijai/ComfyUI-FramePackWrapper.git
clone_or_pull https://github.com/orssorbit/ComfyUI-wanBlockswap.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
clone_or_pull https://github.com/Fannovel16/comfyui_controlnet_aux.git
clone_or_pull https://github.com/shinich39/comfyui-get-meta.git
clone_or_pull https://github.com/kijai/ComfyUI-DepthAnythingV2.git

# GGUF support
clone_or_pull https://github.com/city96/ComfyUI-GGUF.git

echo "########################################"
echo "[INFO] Install Deps..."
echo "########################################"
PARENT_DIR="/root/ComfyUI/custom_nodes" # <--- Change this to your actual parent folder path

if [ ! -d "$PARENT_DIR" ]; then
  echo "Error: Parent directory '$PARENT_DIR' not found."
  exit 1
fi

echo "Searching direct subfolders of '$PARENT_DIR' for 'requirements.txt'..."

for dir in "$PARENT_DIR"/*/; do
  # Check if it's a directory (the glob */ ensures this, but an explicit check is safer)
  if [ -d "$dir" ]; then
    if [ -f "${dir}requirements.txt" ]; then # Note: $dir will have a trailing slash
      echo "----------------------------------------------------"
      echo "Found requirements.txt in: $dir"
      echo "Installing packages..."
      (
        cd "$dir" || { echo "Failed to cd into $dir"; exit 1; }
        pip install -r requirements.txt
        echo "Finished processing: $dir"
      )
      echo "----------------------------------------------------"
    fi
  fi
done
