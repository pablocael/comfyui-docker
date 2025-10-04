#!/bin/bash

set -e

python3 -m venv /root/python-env
source /root/python-env/bin/activate

# Run user's set-proxy script
cd /root
if [ ! -f "/root/user-scripts/set-proxy.sh" ] ; then
    mkdir -p /root/user-scripts
    cp /runner-scripts/set-proxy.sh.example /root/user-scripts/set-proxy.sh
else
    echo "[INFO] Running set-proxy script..."

    chmod +x /root/user-scripts/set-proxy.sh
    source /root/user-scripts/set-proxy.sh
fi ;

# Install ComfyUI
cd /root
if [ ! -f "/root/.download-complete" ] ; then
    chmod +x /runner-scripts/download.sh
    bash /runner-scripts/download.sh
else
    echo "All download steps have been completed before, skipping download step"
fi ;

# Run user's pre-start script
cd /root
if [ ! -f "/root/user-scripts/pre-start.sh" ] ; then
    mkdir -p /root/user-scripts
    cp /runner-scripts/pre-start.sh.example /root/user-scripts/pre-start.sh
else
    echo "[INFO] Running pre-start script..."

    chmod +x /root/user-scripts/pre-start.sh
    source /root/user-scripts/pre-start.sh
fi ;

echo "########################################"
echo "[INFO] Starting ComfyUI..."
echo "########################################"


mkdir -p /run/sshd && chmod 0755 /run/sshd

# --- Enable SSH ---
mkdir -p /run/sshd && \
    ssh-keygen -A && \
    sed -i 's/^#\?Port .*/Port 122/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

/usr/sbin/sshd -p 122 &
echo "[INFO] SSHD started on port 122"

cd /root
python3 ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
