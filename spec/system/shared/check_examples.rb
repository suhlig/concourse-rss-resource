# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
shared_examples 'check' do
  context 'the feed cannot be found' do
    before do
      pipe_in_file('../../spec/fixtures/check/feed-url-404.json') && close_input
    end

    it 'bails out' do
      expect(last_command_started).to_not be_successfully_executed
    end

    it 'prints an error message' do
      stop_all_commands # required to read stderr
      expect(last_command_started.stderr).to include('Not Found')
      expect(last_command_started.stdout).to be_empty
    end
  end

  context 'the feed cannot be parsed' do
    before do
      pipe_in_file('../../spec/fixtures/check/feed-parse-error.json') && close_input
    end

    it 'bails out' do
      expect(last_command_started).to_not be_successfully_executed
    end

    it 'prints an error message' do
      stop_all_commands # required to read stderr
      expect(last_command_started.stderr).to include('well formed')
      expect(last_command_started.stdout).to be_empty
    end
  end

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
