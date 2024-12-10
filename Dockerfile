ARG UBUNTU_CUDA_VERSION=11.7.1-cudnn8-devel-ubuntu20.04
FROM nvidia/cuda:$UBUNTU_CUDA_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

# Update and install dependencies
RUN apt-get update && apt-get -q install -y --no-install-recommends --fix-missing \
    automake \
    autoconf \
    build-essential \
    git \
    libbz2-dev \
    libegl1 \
    libfontconfig1 \
    libgl1 \
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
RUN apt-get -q install -y --no-install-recommends --fix-missing \
    x11proto-dev \
    x11proto-gl-dev \
    xvfb
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add build arguments
ARG BLENDER_VERSION=3.6.18
ARG BLENDER_MIRROR_URL=https://mirror.clarkson.edu/blender/release

# Update Blender installation to use both arguments
RUN echo "Blender URL: ${BLENDER_MIRROR_URL}/Blender${BLENDER_VERSION%.*}/blender-${BLENDER_VERSION}-linux-x64.tar.xz"
RUN wget --no-verbose --show-progress --progress=dot:giga \
    ${BLENDER_MIRROR_URL}/Blender${BLENDER_VERSION%.*}/blender-${BLENDER_VERSION}-linux-x64.tar.xz -O /tmp/blender.tar.xz \
        && tar -xf /tmp/blender.tar.xz -C /opt/ \
        && mv /opt/blender-${BLENDER_VERSION}-linux-x64 /opt/blender \
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

ENV EGL_DRIVER=nvidia
ENV __EGL_VENDOR_LIBRARY_DIRS=/usr/share/glvnd/egl_vendor.d
