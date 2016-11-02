# frozen_string_literal: true
require 'spec_helper'
require 'shared/in_spec'

describe 'when `in` is executed directly', type: 'aruba' do
  let(:destination_directory) { 'resource-destination' }
  let(:destination_file) { File.join(destination_directory, 'version') }

  before do
    create_directory(destination_directory)
    run "bin/in #{destination_directory}"
  end

  include_examples 'in'

  it 'fetches the resource and places it in the given directory' do
    pipe_in_file('../../spec/fixtures/in/input.json') && close_input

    expect(last_command_started).to be_successfully_executed
    expect(file?(destination_file)).to be_truthy
    expect(destination_file).to have_file_content /61cebf/
  end
end
