FROM ipfs/kubo:v0.38.2

ENV IPFS_PROFILE=server
ENV IPFS_SWARM_ADDR=/ip4/0.0.0.0/tcp/4001
ENV IPFS_API_ADDR=/ip4/0.0.0.0/tcp/5001
ENV IPFS_GATEWAY_ADDR=/ip4/0.0.0.0/tcp/8080

# Expose container internal ports (these MUST stay fixed)
EXPOSE 4001/tcp
EXPOSE 4001/udp
EXPOSE 5001/tcp
EXPOSE 8080/tcp

# Auto-init script
RUN printf '#!/bin/sh\n\
set -e\n\
if [ ! -f /data/ipfs/config ]; then\n\
  echo "No IPFS repo found, running ipfs init...";\n\
  ipfs init --profile=$IPFS_PROFILE;\n\
fi;\n\
# Ensure API + Gateway listen on 0.0.0.0\n\
ipfs config Addresses.API $IPFS_API_ADDR\n\
ipfs config Addresses.Gateway $IPFS_GATEWAY_ADDR\n\
ipfs config Addresses.Swarm [\"$IPFS_SWARM_ADDR\",\"/ip6/::/tcp/4001\"]\n\
exec ipfs daemon --migrate=true --enable-gc\n' \
> /usr/local/bin/start-ipfs && chmod +x /usr/local/bin/start-ipfs

ENTRYPOINT ["sh", "/usr/local/bin/]()
