FROM ipfs/kubo:v0.38.2

ENV IPFS_PROFILE=server

# Expose internal container ports
EXPOSE 4001/tcp
EXPOSE 4001/udp
EXPOSE 5001/tcp
EXPOSE 8080/tcp

# Entry script to auto-init IPFS if repo doesn't exist
RUN printf '#!/bin/sh\n\
set -e\n\
if [ ! -f /data/ipfs/config ]; then\n\
  echo "No IPFS repo found, running ipfs init...";\n\
  ipfs init --profile=$IPFS_PROFILE;\n\
fi;\n\
exec ipfs daemon --migrate=true\n' \
> /usr/local/bin/start-ipfs && chmod +x /usr/local/bin/start-ipfs

ENTRYPOINT ["sh", "/usr/local/bin/start-ipfs"]
