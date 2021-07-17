FROM ruby:alpine

WORKDIR /resource
COPY Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development test'
RUN bundle install --jobs 4

COPY . .

RUN ln -s /resource/bin /opt/resource
