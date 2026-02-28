# frozen_string_literal: true

require 'system/shared/out_examples'
require 'securerandom'

describe 'when `out` is executed in a docker container', type: 'aruba' do
  let(:host_source_directory) { "/tmp/#{SecureRandom.uuid}" }
  let(:container_source_directory) { '/concourse' }
  let(:container_source_file) { File.join(container_source_directory, 'resource_contents') }

  before do
    `docker build --build-arg=RUBY_VERSION=$RUBY_VERSION-alpine -t suhlig/concourse-rss-resource:latest .`

    # We don't necessarily have access to the docker host's file system from
    # this test, so we create the resource contents by mounting another container
    # with the same volume as the one that created the file.
    run_command "docker run --rm \
      --volume #{host_source_directory}:#{container_source_directory} \
      suhlig/concourse-rss-resource \
      'echo #{resource_contents} > #{container_source_file}'"

    run_command "docker run --rm --interactive \
         --volume #{host_source_directory}:#{container_source_directory} \
         suhlig/concourse-rss-resource \
         /opt/resource/out #{container_source_directory}"
  end

  include_examples 'out'
end
