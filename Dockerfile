FROM rust:latest as cargo-build

RUN apt-get update

RUN apt-get install musl-tools -y

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/bradman
COPY . .
RUN cargo clean
RUN RUSTFLAGS=-Clinker=musl-gcc  cargo build --release --target=x86_64-unknown-linux-musl 
RUN rm -f target/x86_64-unknown-linux-musl/release/deps/myapp*
COPY . .

RUN cargo install --path . 

FROM alpine:latest
COPY --from=cargo-build /usr/src/bradman/target/x86_64-unknown-linux-musl/release/bradman /usr/local/bin/bradman
CMD ["bradman"]
