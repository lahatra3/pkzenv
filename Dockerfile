FROM ubuntu:26.04

# Build args
ARG ZIG_VERSION=0.16.0
ARG ZIG_INSTALL_DIR=/usr/local/zig
ARG LIBRDKAFKA_VERSION=2.13.0
ARG LIBPQ_VERSION=18.3

# Metadata
LABEL maintainer="lahatra3"
LABEL description="Zig ${ZIG_VERSION} + librdkafka ${LIBRDKAFKA_VERSION} + libpq ${LIBPQ_VERSION} build environment"

# Set environment variables
ENV PATH=$PATH:${ZIG_INSTALL_DIR}

# Install dependencies and Zig in a single layer to reduce image size
RUN apt update -y && \
    apt install -y --no-install-recommends \
        bash \
        librdkafka-dev=${LIBRDKAFKA_VERSION}-1 \
        libpq5=${LIBPQ_VERSION}-1 \
        libpq-dev=${LIBPQ_VERSION}-1 \
        curl \
        xz-utils \
        ca-certificates && \
     # Install Zig
    curl -L https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz -o zig.tar.xz && \
    mkdir -p ${ZIG_INSTALL_DIR} && \
    tar -xf zig.tar.xz --strip-components=1 -C ${ZIG_INSTALL_DIR} && \
    rm zig.tar.xz && \
    # Remove cache
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD ["/bin/bash"]
