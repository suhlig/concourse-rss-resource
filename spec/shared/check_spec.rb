# frozen_string_literal: true
require 'spec_helper'

shared_examples 'check' do
  it 'produces the right JSON output' do
    pipe_in_file('../../spec/fixtures/check/input.json')
    close_input

    expect(last_command_started).to be_successfully_executed
    expect(last_command_started.stdout).to be_json
    expect(last_command_started.stdout).to be_json_including('source' => { 'uri' => 'git://some-uri' })
  end

  it 'provides diagnostic messages' do
    pipe_in_file('../../spec/fixtures/check/input.json')
    close_input

    expect(last_command_started).to be_successfully_executed
    expect(last_command_started.stderr).to match(/version/)
  end
end
