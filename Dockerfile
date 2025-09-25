FROM ubuntu:22.04

# Gunakan mirror Indonesia
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://repo.ugm.ac.id/ubuntu/|g' /etc/apt/sources.list

# Install basic tools (tanpa yq)
RUN apt-get update -o Acquire::Retries=5 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl wget git zip unzip nano vim htop jq make gcc g++ cmake \
    python3 python3-pip \
    php php-cli composer \
    openjdk-17-jdk \
    golang-go \
    ruby-full \
    rustc cargo \
    dotnet-sdk-6.0 \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Install yq (binary)
RUN wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" \
    && chmod +x /usr/local/bin/yq

# Node.js & NPM & PM2 (pisah agar cache optimal)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g pm2

# GitHub CLI (pisah agar cache optimal)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt-get update && apt-get install -y gh

# Set default shell
CMD ["bash"]
