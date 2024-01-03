#!/usr/bin/env bash

set -e

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

if [[ "$1" == "--32bit" ]]; then
  dpkg --add-architecture i386
fi
apt-get update

package_list="
    ca-certificates \
    curl \
    file \
    gnupg \
    libnotify-bin \
    locales \
    lsb-release \
    nano \
    python2 \
    python-dbus \
    python-setuptools \
    python3-pip \
    sudo \
    vim-nox \
    wget \
    lsof \
    libfuse2 \
    software-properties-common \
    desktop-file-utils \
    xvfb"

package_list_32bit="
    g++-multilib \
    libgl1:i386 \
    libgtk-3-0:i386 \
    libgdk-pixbuf2.0-0:i386 \
    libdbus-1-3:i386
    libgbm1:i386 \
    libnss3:i386 \
    libcurl4:i386 \
    libasound2:i386"

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $package_list
if [[ "$1" == "--32bit" ]]; then
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $package_list_32bit
fi
    

add-apt-repository ppa:git-core/ppa -y && apt-get update

# Download deps installation files from Chromium
curl https://chromium.googlesource.com/chromium/src/+/HEAD/build/install-build-deps.sh\?format\=TEXT | base64 --decode | cat > /setup/install-build-deps.sh
curl https://chromium.googlesource.com/chromium/src/+/HEAD/build/install-build-deps.py\?format\=TEXT | base64 --decode | cat > /setup/install-build-deps.py

# Remove snapcraft to avoid issues on docker build
sed -i 's/packages.append("snapcraft")/print("skipping snapcraft")/g' /setup/install-build-deps.py

# Ensure installation files are executable
chmod +x /setup/install-build-deps.sh
chmod +x /setup/install-build-deps.py

if [[ "$1" == "--32bit" ]]; then
  DEBIAN_FRONTEND=noninteractive bash /setup/install-build-deps.sh --syms --no-prompt --no-chromeos-fonts --lib32 --arm --no-nacl
elif [[ "$1" == "--arm" ]]; then
  echo Not installing Chromium deps
else
  DEBIAN_FRONTEND=noninteractive bash /setup/install-build-deps.sh --syms --no-prompt --no-chromeos-fonts --no-arm --no-nacl
fi
rm -rf /var/lib/apt/lists/*

# No Sudo Prompt
echo 'builduser ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-builduser
echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

# Install Node.js
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install nodejs -y

# Install pip for python2 usage
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
python2 get-pip.py

# crcmod is required by gsutil, which is used for filling the gclient git cache
pip install wheel
pip install -U crcmod

# TODO: We can remove this step once transition to using python3 to run Electron tests is complete.
pip install python-dbusmock==0.20.0

# dbusmock is needed for Electron tests
pip3 install wheel
pip3 install python-dbusmock==0.20.0

mkdir /tmp/workspace
chown builduser:builduser /tmp/workspace
