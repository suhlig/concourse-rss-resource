# frozen_string_literal: true

require 'system/shared/check_examples'

describe 'when `check` is executed in a docker container', type: 'aruba' do
  before do
    `docker build --build-arg=RUBY_VERSION=$RUBY_VERSION-alpine -t suhlig/concourse-rss-resource:latest .`
    run_command 'docker run --rm --interactive suhlig/concourse-rss-resource /opt/resource/check'
  end

  include_examples 'check'
end
