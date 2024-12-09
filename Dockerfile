# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to non-interactive to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libglu1-mesa \
    libxi6 \
    libxinerama1 \
    libx11-6 \
    libxrandr2 \
    libgl1-mesa-glx \
    libxt6 \
    libssl-dev \
    wget \
    xorg-dev \
    tcl8.6 \
    tk8.6 \
    libfftw3-dev \
    libpng-dev \
    libjpeg-dev \
    libz-dev \
    curl \
    ca-certificates \
    python3 \
    python3-pip \
    python3-dev \
    && apt-get clean

# Download and install VMD
RUN wget https://www.ks.uiuc.edu/Research/vmd/vmd-1.9.4a52.bin.LINUXAMD64-CUDA8-OSPRay.tar.gz && \
    tar -xvzf vmd-1.9.4a52.bin.LINUXAMD64-CUDA8-OSPRay.tar.gz && \
    rm vmd-1.9.4a52.bin.LINUXAMD64-CUDA8-OSPRay.tar.gz && \
    cd VMD-v1.9.4a52 && \
    ./configure  # This will configure VMD for your system

# Set the default working directory
WORKDIR /VMD-v1.9.4a52

# Install VMD (make sure you install it without GUI if you want to run headlessly)
RUN ./install

# Set VMD environment variables
ENV VMDINSTALLDIR=/VMD-v1.9.4a52
ENV PATH="$VMDINSTALLDIR/bin:$PATH"
ENV LD_LIBRARY_PATH="$VMDINSTALLDIR/lib:$LD_LIBRARY_PATH"
ENV VMD_NOGUI=1

# Install PyTorch and Chai-Lab
RUN pip3 install torch==2.5.1 chai_lab==0.5.0

# Set the entry point (you can change this to run specific VMD commands)
ENTRYPOINT ["vmd", "-dispdev", "text"]

# Expose a port (optional, if you want to connect to the container via other means)
EXPOSE 8080

# Start VMD in headless mode by default
CMD ["-e", "your_script.tcl"]
