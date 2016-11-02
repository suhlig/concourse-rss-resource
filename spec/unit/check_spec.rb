# frozen_string_literal: true
require 'spec_helper'
require "rspec/json_matcher"
RSpec.configuration.include RSpec::JsonMatcher

describe 'check', type: 'aruba' do
  it 'produces JSON' do
    run 'bin/check'
    pipe_in_file('../../spec/fixtures/check/input.json')
    close_input
    expect(last_command_started).to be_successfully_executed

    expect(last_command_started.stdout).to be_json
    expect(last_command_started.stderr).to match(/version/)
  end
end
