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
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Install wetty globally
RUN npm install -g wetty

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
RUN echo "bind-addr: 127.0.0.1:8080\nauth: none\ncert: false" > ~/.config/code-server/config.yaml

# Switch back to root for final setup
USER root

# Copy nginx configuration and HTML files
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html/index.html

# Expose port for nginx
EXPOSE 80

# Copy and set up start script
COPY start-services.sh /start-services.sh
RUN chmod +x /start-services.sh

CMD ["/start-services.sh"]