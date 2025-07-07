# Use phoronix/pts as the base image
FROM phoronix/pts:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       php-sqlite3 \
       zip \
       unzip \
       php-zip \
       build-essential \
       autoconf

# Clean up to reduce image size
RUN apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Set environment variable for Phoromatic server port
ENV PHOROMATIC_HTTP_PORT=8287

# Expose Phoromatic server port
EXPOSE 8287/tcp

# Start Phoromatic server when container starts
CMD ["/phoronix-test-suite/phoronix-test-suite", "start-phoromatic-server"]
