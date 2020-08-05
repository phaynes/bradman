FROM rust:latest as cargo-build

RUN apt-get update -yqq && apt-get install -yqq cmake g++

RUN apt-get install musl-tools -y

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/bradman
COPY . .
RUN cargo clean
RUN RUSTFLAGS="-Clinker=musl-gcc -Ctarget-cpu=native" cargo build --release --target=x86_64-unknown-linux-musl 
RUN rm -f target/x86_64-unknown-linux-musl/release/deps/myapp*
COPY . .

RUN cargo install --path . 

FROM alpine:latest
COPY --from=cargo-build /usr/src/bradman/target/x86_64-unknown-linux-musl/release/bradman /usr/local/bin/bradman

RUN ln -sf /dev/stdout /var/log/access.log \
    && ln -sf /dev/stderr /var/log/error.log
    
EXPOSE 80 443 8080 

CMD ["bradman"]
