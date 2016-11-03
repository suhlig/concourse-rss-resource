# frozen_string_literal: true
require 'spec_helper'

shared_examples 'check' do
  context 'the first request' do
    it 'responds with just the current version' do
      pipe_in_file('../../spec/fixtures/check/first_input.json') && close_input

      expect(last_command_started).to be_successfully_executed
      expect(last_command_started.stdout).to be_json
    end
  end

  context 'a consecutive request' do
    it 'responds with all versions since the requested one' do
      pipe_in_file('../../spec/fixtures/check/input.json') && close_input

      expect(last_command_started).to be_successfully_executed
      expect(last_command_started.stdout).to be_json
    end
  end
end
