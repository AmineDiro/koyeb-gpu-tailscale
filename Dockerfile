FROM pytorch/pytorch:2.7.1-cuda12.6-cudnn9-devel

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    iptables \
    bash \
    curl \
    wget \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3-pip \
    openssh-client \
    git \
    ca-certificates \
    sudo \
    rsync \
    gnupg \
    software-properties-common \
    apt-transport-https \
    lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Create python3 symlink for Ansible compatibility \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    update-alternatives --set python3 /usr/bin/python3.9 && \
    # Upgrade pip \
    python3.9 -m pip install --upgrade pip

WORKDIR /app

COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
