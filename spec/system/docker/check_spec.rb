# frozen_string_literal: true
require 'spec_helper'
require 'shared/check_spec'

describe 'when `check` is executed in a docker container', type: 'aruba' do
  before do
    `docker build -t suhlig/rss-resource:latest .`
    run 'docker run --rm --interactive suhlig/rss-resource /opt/resource/check'
  end

  include_examples 'check'
end
