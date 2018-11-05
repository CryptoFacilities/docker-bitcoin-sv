FROM debian:sid as builder

RUN apt-get update && apt-get install -y curl

ENV BSV_VERSION=0.1.0
ENV BSV_CHECKSUM="bb4a8049698bb6723526e1bd457a7cfdb919eac491ee3c3b563c6c159ad278e3 bitcoin-sv-${BSV_VERSION}-x86_64-linux-gnu.tar.gz"

RUN curl -SLO "https://github.com/bitcoin-sv/bitcoin-sv/releases/download/v${BSV_VERSION}/bitcoin-sv-${BSV_VERSION}-x86_64-linux-gnu.tar.gz" \
  && echo "${BSV_CHECKSUM}" | sha256sum -c - | grep OK \
  && tar -xzf bitcoin-sv-${BSV_VERSION}-x86_64-linux-gnu.tar.gz

FROM debian:sid-slim
ENV BSV_VERSION=0.1.0
RUN useradd -m bitcoin
USER bitcoin
COPY --from=builder /bitcoin-sv-${BSV_VERSION}/bin/bitcoind /bin/bitcoind
RUN mkdir -p /home/bitcoin/.bitcoin
CMD ["bitcoind","-printtoconsole"]
