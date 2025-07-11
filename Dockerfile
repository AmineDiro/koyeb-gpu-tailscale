FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu20.04:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y iptables bash curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

COPY start.sh /app/start.sh

CMD ["/app/start.sh"]
