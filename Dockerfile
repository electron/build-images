FROM ubuntu:22.04

RUN groupadd --gid 999 builduser \
  && useradd --uid 999 --gid builduser --shell /bin/bash --create-home builduser \
  && mkdir -p /setup

# Set up TEMP directory
ENV TEMP=/tmp
RUN chmod a+rwx /tmp

# Install Linux packages
ADD tools/install-deps.sh /tmp/
ADD tools/azure_cli_deb_install.sh /tmp/
RUN bash /tmp/install-deps.sh --32bit

# Add xvfb init script
ADD tools/xvfb-init.sh /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb

RUN rm -rf /var/lib/apt/lists/*

USER builduser
WORKDIR /home/builduser
