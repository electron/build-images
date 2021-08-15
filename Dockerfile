FROM ubuntu:18.04

RUN groupadd --gid 1000 builduser \
  && useradd --uid 1000 --gid builduser --shell /bin/bash --create-home builduser \
  && mkdir -p /setup

# Set up TEMP directory
ENV TEMP=/tmp
RUN chmod a+rwx /tmp

# Install Linux packages
ADD tools/install-deps.sh /tmp/
RUN bash /tmp/install-deps.sh --multiarch

# Add xvfb init script
ADD tools/xvfb-init.sh /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb

USER builduser
WORKDIR /home/builduser
