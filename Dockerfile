# Base IPFS Kubo image
FROM ipfs/kubo:v0.38.2

# Set environment variables
ENV IPFS_PROFILE=server

# Create folders inside the container
RUN mkdir -p /export && mkdir -p /data/ipfs

# Expose ports (internal container ports)
# Host mapping is done at "docker run" time
EXPOSE 4001/tcp
EXPOSE 4001/udp
EXPOSE 5001/tcp
EXPOSE 8080/tcp

# Default entrypoint (comes from Kubo image)
ENTRYPOINT ["ipfs"]
CMD ["daemon", "--migrate=true"]
