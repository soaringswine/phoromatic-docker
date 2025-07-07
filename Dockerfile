# -------- Builder Stage ----------------------------------------------------
FROM ubuntu:20.04 AS builder

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install tools required for building the Phoronix Test Suite
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       git \
       build-essential \
       autoconf \
       php-cli \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /tmp

# Fetch and install the Phoronix Test Suite
RUN git clone https://github.com/phoronix-test-suite/phoronix-test-suite.git \
    && cd phoronix-test-suite \
    && ./install-sh /usr

# -------- Runtime Stage ----------------------------------------------------
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install only the packages required at runtime
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       php-cli \
       php-sqlite3 \
       zip \
       unzip \
       php-zip \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Copy the built Phoronix Test Suite from the builder image
COPY --from=builder /usr/bin/phoronix-test-suite /usr/bin/phoronix-test-suite
COPY --from=builder /usr/share/phoronix-test-suite /usr/share/phoronix-test-suite

# Set environment variable for Phoromatic server port
ENV PHOROMATIC_HTTP_PORT=8287

# Expose Phoromatic server port
EXPOSE 8287/tcp

# Start Phoromatic server when container starts
CMD ["phoronix-test-suite", "start-phoromatic-server"]
