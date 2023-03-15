FROM ubuntu:focal

WORKDIR /app

RUN apt-get update \
  && apt-get -y upgrade

# Install dependencies
RUN apt-get -y install curl git build-essential libsqlite3-dev

# Install rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Build the tracker
ADD tracker ./src
WORKDIR /app/src
RUN /root/.cargo/bin/cargo build --release

# Prepare prod env
WORKDIR /app/bin
RUN cp /app/src/target/release/torrust-tracker . \
  && mkdir -p ./storage/database
COPY ./config.toml .

EXPOSE 6969/udp
EXPOSE 7070/tcp
EXPOSE 1212/tcp

ENTRYPOINT ["/app/bin/torrust-tracker"]