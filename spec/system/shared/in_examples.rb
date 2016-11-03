# frozen_string_literal: true
require 'spec_helper'

shared_examples 'in' do
  it 'fetches the resource and responds with the fetched version and its metadata' do
    pipe_in_file('../../spec/fixtures/in/input.json') && close_input

    expect(last_command_started).to be_successfully_executed
    expect(last_command_started.stdout).to be_json
    expect(last_command_started.stdout).to be_json_as({
      'version'  => { 'ref' => '61cebf' },
      'metadata' => [
        { 'name' => 'commit', 'value' => '61cebf' },
        { 'name' => 'author', 'value' => 'Hulk Hogan' },
      ]
    })
  end
end
