# Use phoronix/pts as the base image for building
FROM phoronix/pts:latest AS builder

# Avoid prompts from apt during build
ENV DEBIAN_FRONTEND=noninteractive

# Install packages needed to prepare the runtime image
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       php-sqlite3 \
       zip \
       unzip \
       php-zip \
       build-essential \
       autoconf \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Copy the Phoronix Test Suite for later use
COPY . /phoronix-test-suite

######################################################################

FROM phoronix/pts:latest

# Avoid prompts from apt in the final image
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime packages only
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       php-sqlite3 \
       zip \
       unzip \
       php-zip \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Copy built files from the builder stage
COPY --from=builder /phoronix-test-suite /phoronix-test-suite

# Create phoromatic user and group
RUN groupadd -r phoromatic && useradd -r -g phoromatic phoromatic \
    && mkdir -p /phoronix-test-suite \
    && chown -R phoromatic:phoromatic /phoronix-test-suite

# Set environment variable for Phoromatic server port
ENV PHOROMATIC_HTTP_PORT=8287

# Expose Phoromatic server port
EXPOSE 8287/tcp

# Use phoromatic user to run the server
USER phoromatic

# Start Phoromatic server when container starts
CMD ["/phoronix-test-suite/phoronix-test-suite", "start-phoromatic-server"]
