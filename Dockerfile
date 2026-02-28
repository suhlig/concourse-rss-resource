ARG RUBY_VERSION=4
FROM ruby:${RUBY_VERSION}-alpine
LABEL org.opencontainers.image.source=https://github.com/suhlig/concourse-rss-resource

RUN apk add --no-cache build-base && rm -rf /var/cache/apk/*

WORKDIR /resource
COPY Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development test'
RUN bundle install

COPY . .

RUN ln -s /resource/bin /opt/resource
