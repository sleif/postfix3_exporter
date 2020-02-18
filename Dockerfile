# Builder stage to
FROM golang:1.12 as builder

# Add the project in the image
ADD . /go/src/github.com/sleif/postfix_exporter
WORKDIR /go/src/github.com/sleif/postfix_exporter

# Install needed dependencies for the build
RUN apt-get update -q && apt-get install -qy \
  build-essential \
  libsystemd-dev

# Get dependencies and build the static binary
RUN go get -d ./...
RUN go build -a -tags static_all

# Real image
FROM debian:latest

EXPOSE 9154
WORKDIR /

# Copy the binary from the build image to the real one
COPY --from=builder /go/src/github.com/sleif/postfix_exporter/postfix_exporter .

ENTRYPOINT ["/postfix_exporter"]
