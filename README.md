# Phoromatic Docker Image

This repository provides a Dockerfile for running the [Phoromatic](https://www.phoronix-test-suite.com/) server.

## Prerequisites

- [Docker](https://www.docker.com/) installed and running.

## Building the Image

Run the following command in the repository root to build the Docker image:

```sh
docker build -t phoromatic .
```

## Running the Container

Start the Phoromatic server container and expose the web interface on port `8287`:

```sh
docker run -p 8287:8287 phoromatic
```

After the container starts, navigate to `http://localhost:8287/` in your web browser to access the Phoromatic interface.

