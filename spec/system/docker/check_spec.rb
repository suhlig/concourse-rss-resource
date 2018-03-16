# frozen_string_literal: true

require 'system/shared/check_examples'

describe 'when `check` is executed in a docker container', type: 'aruba' do
  before do
    `docker build -t suhlig/concourse-rss-resource:latest .`
    run 'docker run --rm --interactive suhlig/concourse-rss-resource /opt/resource/check'
  end

  include_examples 'check'
end
