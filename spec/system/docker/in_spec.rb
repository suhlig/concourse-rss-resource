# frozen_string_literal: true
require 'spec_helper'
require 'system/shared/in_examples'
require 'securerandom'

describe 'when `in` is executed in a docker container', type: 'aruba' do
  let(:host_destination_directory) { "/tmp/#{SecureRandom.uuid}" }
  let(:container_destination_directory) { '/concourse' }
  let(:container_destination_file) { File.join(container_destination_directory, 'version') }

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
    contents = `docker run --rm \
                  --volume #{host_destination_directory}:#{container_destination_directory} \
                  suhlig/concourse-rss-resource \
                  cat #{container_destination_file}`

    expect(contents).to be_json
    expect(contents).to be_json_as({
      'version' => { 'ref' => '61cebf' }
    })
  end
end
