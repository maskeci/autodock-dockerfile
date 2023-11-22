# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to suppress interactive installation prompts
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    tar \
    libx11-6 \
    libgl1-mesa-glx \
    libglu1-mesa \
    libxmu6 \
    libxi6 \
    && rm -rf /var/lib/apt/lists/*

# Download and extract MGLTools
WORKDIR /opt
RUN wget --trust-server-names --content-disposition https://ccsb.scripps.edu/mgltools/download/491/ && \
    tar -xzf $(ls *.tar.gz) && \
    rm *.tar.gz

# Install MGLTools
WORKDIR /opt/mgltools_x86_64Linux2_1.5.7
RUN ./install.sh

# Download and extract Autodock4
WORKDIR /opt
RUN wget --trust-server-names --content-disposition https://autodock.scripps.edu/wp-content/uploads/sites/56/2021/10/autodocksuite-4.2.6-x86_64Linux2.tar && \
    tar -xf $(ls *.tar) && \
    mv x86_64Linux2/*  /opt/mgltools_x86_64Linux2_1.5.7/bin && \
    rm *.tar

# Download and extract AD Covalent script files
WORKDIR /opt
RUN wget --trust-server-names --content-disposition https://autodock.scripps.edu/download/468/ && \
    tar -xzf $(ls *.tar.gz) &&  \
    mv adCovalentDockResidue/adcovalent/*  /opt/mgltools_x86_64Linux2_1.5.7/bin && \
    rm *.tar.gz
    
# Add binaries to the PATH
ENV PATH="/opt/mgltools_x86_64Linux2_1.5.7/bin:${PATH}"

# Enable core dumps
RUN ulimit -c unlimited

# Set the working directory
WORKDIR /home

# Command to run when the container starts
CMD ["bash"]
