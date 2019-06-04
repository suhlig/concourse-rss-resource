# frozen_string_literal: true

require 'system/shared/in_examples'

describe 'when `in` is executed directly', type: 'aruba' do
  let(:destination_directory) { 'resource-destination' }

  before do
    create_directory(destination_directory)
    run_command "bin/in #{destination_directory}"
  end

  include_examples 'in'

  it 'fetches the resource and places it in the given directory' do
    pipe_in_file('../../spec/fixtures/in/input.json') && close_input

    expect(last_command_started).to be_successfully_executed
    destination_file = File.join(destination_directory, 'title')
    expect(file?(destination_file)).to be_truthy
  end
end
