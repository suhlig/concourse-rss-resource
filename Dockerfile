FROM ruby:alpine

RUN bundle config --global frozen 1
WORKDIR /resource
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --without development test

COPY . .

RUN ln -s /resource/bin /opt/resource
