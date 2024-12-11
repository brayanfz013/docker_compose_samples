FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Instalar software adicional (opcional)

# ...

CMD ["/bin/bash"]