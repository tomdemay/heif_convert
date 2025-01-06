# Define a global build argument for the install directory
ARG INSTALL_DIR=/opt/build-artifacts

# Stage 1: Build stage
FROM gcc:12 as build

# Install necessary tools and libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake wget build-essential && \
    rm -rf /var/lib/apt/lists/*

# Create a common installation directory
ARG INSTALL_DIR
ENV INSTALL_DIR=$INSTALL_DIR
RUN mkdir -p $INSTALL_DIR 

# Download and build libde265
RUN wget https://github.com/strukturag/libde265/archive/refs/tags/v1.0.11.tar.gz && \
    tar -xzf v1.0.11.tar.gz && \
    cd libde265-1.0.11 && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR .. && \
    make && \
    make install

# Download and build libheif
RUN wget https://github.com/strukturag/libheif/archive/refs/tags/v1.18.0.tar.gz && \
    tar -xzf v1.18.0.tar.gz && \
    cd libheif-1.18.0 && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR .. && \
    make && \
    make install

# Stage 2: Runtime stage
FROM debian:12.8-slim as final

# Install only runtime dependencies and clean up apt cache to minimize image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    libjpeg62-turbo libpng16-16 libtiff6 libwebp7 && \
    rm -rf /var/lib/apt/lists/*

# Copy only the built libraries and binaries from the build stage
ARG INSTALL_DIR
COPY --from=build ${INSTALL_DIR} /usr/local/

# Create symlink for heif-convert
RUN ln -sf /usr/local/bin/heif-dec /usr/local/bin/heif-convert

# Update shared library cache
RUN ldconfig
