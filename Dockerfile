# Use Ubuntu as the base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# Switch to the non-root user
USER coder
WORKDIR /home/coder

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install some common VS Code extensions
RUN code-server --install-extension ms-python.python \
    && code-server --install-extension dbaeumer.vscode-eslint \
    && code-server --install-extension esbenp.prettier-vscode

# Create config directory and add default settings
RUN mkdir -p ~/.config/code-server
RUN echo "bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme\ncert: false" > ~/.config/code-server/config.yaml

# Expose the web interface port
EXPOSE 8080

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]