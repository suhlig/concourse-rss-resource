# frozen_string_literal: true
require 'spec_helper'
require 'system/shared/in_examples'
require 'securerandom'

describe 'when `in` is executed in a docker container', type: 'aruba' do
  let(:host_destination_directory) { "/tmp/#{SecureRandom.uuid}" }
  let(:container_destination_directory) { '/concourse' }

  before do
    `docker build -t suhlig/concourse-rss-resource:latest .`

    run "docker run --rm --interactive \
         --volume #{host_destination_directory}:#{container_destination_directory} \
         suhlig/concourse-rss-resource \
         /opt/resource/in #{container_destination_directory}"
  end

  include_examples 'in'

  it 'fetches the resource and places it in the given directory' do
    pipe_in_file('../../spec/fixtures/in/input.json') && close_input

    expect(last_command_started).to be_successfully_executed

    # We don't necessarily have access to the docker host's file system from
    # this test, so we read back the version file by mounting another container
    # with the same volume as the one that created the file.
    files = `docker run --rm \
                  --volume #{host_destination_directory}:#{container_destination_directory} \
                  suhlig/concourse-rss-resource \
                  ls #{container_destination_directory}`

    expect(files.lines).to_not be_empty
    expect(files.lines).to have(5).items
  end
end
