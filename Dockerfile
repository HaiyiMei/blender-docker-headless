FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,video

# Update and install dependencies
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y --no-install-recommends --fix-missing \
    automake \
    autoconf \
    build-essential \
    curl \
    git \
    libbz2-1.0 \
    libegl1 \
    libegl1-mesa \
    libegl-dev \
    libegl1-mesa-dev \
    libfontconfig1 \
    libgl1-mesa-glx \
    libgles2-mesa-dev \
    libglvnd-dev \
    libgtk-3-0 \
    libsm6 \
    libtool \
    libx11-6 \
    libx11-dev \
    libxcursor1 \
    libxext6 \
    libxext-dev \
    libxi6 \
    libxinerama1 \
    libxkbcommon0 \
    libxrandr2 \
    libxrender1 \
    libxxf86vm1 \
    mesa-utils \
    pkg-config \
    wget \
    python3 \
    python3-pip
RUN apt-get install -y --no-install-recommends --fix-missing \
    x11proto-dev \
    x11proto-gl-dev \
    xvfb
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Blender
RUN wget https://mirror.clarkson.edu/blender/release/Blender3.6/blender-3.6.18-linux-x64.tar.xz -O /tmp/blender.tar.xz \
    && tar -xvf /tmp/blender.tar.xz -C /opt/ \
    && mv /opt/blender-3.6.18-linux-x64 /opt/blender \
    && rm /tmp/blender.tar.xz

# Set Blender path
ENV PATH="/opt/blender:$PATH"

# Clone and build libglvnd for NVIDIA EGL support
RUN git clone https://github.com/NVIDIA/libglvnd.git /tmp/libglvnd \
    && cd /tmp/libglvnd \
    && ./autogen.sh \
    && ./configure \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /usr/share/glvnd/egl_vendor.d/ \
    && printf "{\n\
    \"file_format_version\" : \"1.0.0\",\n\
    \"ICD\": {\n\
        \"library_path\": \"libEGL_nvidia.so.0\"\n\
    }\n\
    }" > /usr/share/glvnd/egl_vendor.d/10_nvidia.json \
    && cd / \
    && rm -rf /tmp/libglvnd
