FROM alpine:latest

RUN apk add             \
      --no-cache        \
      ca-certificates   \
      ruby              \
      ruby-bundler      \
      ruby-io-console   \
      ruby-irb          \
      ruby-rake         \
      ruby-bigdecimal   \
      ruby-json

ADD lib /opt/lib
ADD bin /opt/resource
