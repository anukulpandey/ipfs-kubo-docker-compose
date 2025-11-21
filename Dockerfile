FROM ipfs/kubo:v0.38.2

ENV IPFS_PROFILE=server

EXPOSE 4001/tcp
EXPOSE 4001/udp
EXPOSE 5001/tcp
EXPOSE 8080/tcp

RUN printf '#!/bin/sh\n\
set -e\n\
# init repo if missing\n\
if [ ! -f /data/ipfs/config ]; then\n\
  echo "Initializing IPFS...";\n\
  ipfs init --profile=$IPFS_PROFILE;\n\
fi;\n\
# force PUBLIC API address\n\
ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001;\n\
# force PUBLIC Gateway address\n\
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080;\n\
# force PUBLIC Swarm address\n\
ipfs config Addresses.Swarm [\"/ip4/0.0.0.0/tcp/4001\",\"/ip4/0.0.0.0/udp/4001/quic-v1\"];\n\
# start daemon\n\
echo "Starting IPFS Daemon...";\n\
exec ipfs daemon --migrate=true;\n\
' > /usr/local/bin/start-ipfs && chmod +x /usr/local/bin/start-ipfs

ENTRYPOINT ["sh", "/usr/local/bin/start-ipfs"]
