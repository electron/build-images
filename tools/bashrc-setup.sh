#!/usr/bin/env bash

echo export PATH=\"\$PATH:/home/builduser/.electron_build_tools/src\" >> ~/.bashrc
echo "cd /workspaces/gclient/src/electron" >> ~/.bashrc
echo export LC_ALL=\"en_US.UTF-8\" >> ~/.bashrc
