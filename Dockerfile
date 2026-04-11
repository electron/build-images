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

# Pre-populated node-gyp header cache (built on the host, see
# pipeline-docker-build.yml) so parallel `yarn install` postinstall builds in
# CI do not race downloading the same tarball. Left world-writable so node-gyp
# can still self-populate at runtime if the target Node version differs.
ENV npm_config_devdir=/opt/node-gyp-headers
COPY .node-gyp-headers /opt/node-gyp-headers
RUN chmod -R a+rwX /opt/node-gyp-headers

RUN rm -rf /var/lib/apt/lists/*

USER builduser
WORKDIR /home/builduser
