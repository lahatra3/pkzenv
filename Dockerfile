FROM ubuntu:26.04

# Shell configuration for security
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build args
ARG ZIG_VERSION=0.16.0
ARG ZIG_INSTALL_DIR=/usr/local/zig
ARG LIBRDKAFKA_VERSION=2.13.0
ARG LIBPQ_VERSION=18.3

ARG USER_ID=1000
ARG GROUP_ID=1000

# Metadata
LABEL maintainer="lahatra3"
LABEL description="Zig ${ZIG_VERSION} + librdkafka ${LIBRDKAFKA_VERSION} + libpq ${LIBPQ_VERSION} build environment"

# Set environment variables
ENV PATH=${ZIG_INSTALL_DIR}:${PATH}

# Install dependencies librdkafka and libpq
RUN apt update -y && \
    apt install -y --no-install-recommends \
        ca-certificates \
        bash \
        librdkafka-dev=${LIBRDKAFKA_VERSION}-1 \
        libpq5=${LIBPQ_VERSION}-1 \
        libpq-dev=${LIBPQ_VERSION}-1 \
        curl \
        xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Zig
RUN mkdir -p ${ZIG_INSTALL_DIR} && \
    curl -L https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz -o zig.tar.xz && \
    tar -xf zig.tar.xz --strip-components=1 -C ${ZIG_INSTALL_DIR} && \
    rm zig.tar.xz

# Create non root user for security
RUN groupadd -g ${GROUP_ID} -o lahatra3 && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -o lahatra3 && \
    chown -R lahatra3:lahatra3 ${ZIG_INSTALL_DIR}

USER lahatra3

WORKDIR /app

CMD ["/bin/bash"]