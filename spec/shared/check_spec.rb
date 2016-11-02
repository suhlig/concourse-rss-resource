# frozen_string_literal: true
require 'spec_helper'

shared_examples 'check' do
  context 'first request' do
    it 'responds with just the current version' do
      pipe_in_file('../../spec/fixtures/check/first_input.json') && close_input

      expect(last_command_started).to be_successfully_executed
      expect(last_command_started.stdout).to be_json
      expect(last_command_started.stdout).to be_json_as([{ 'ref' => '61cebf' }])
    end
  end

  #
  # TODO
  #
  # from http://concourse.ci/implementing-resources.html#resource-check:
  #
  # * The list may be empty, if there are no versions available at the source.
  # * If the given version is already the latest, an array with that version as
  #   the sole entry should be listed.
  # * If your resource is unable to determine which versions are newer then the
  #   given version (e.g. if it's a git commit that was push -fed over), then
  #   the current version of your resource should be returned (i.e. the new HEAD).

  context 'consecutive request' do
    it 'responds with all versions since the requested one' do
      pipe_in_file('../../spec/fixtures/check/input.json') && close_input

      expect(last_command_started).to be_successfully_executed
      expect(last_command_started.stdout).to be_json
      expect(last_command_started.stdout).to be_json_as([
        { 'ref' => '61cebf' },
        { 'ref' => 'd74e01' },
        { 'ref' => '7154fe' },
      ])
    end

    it 'provides diagnostic messages' do
      pipe_in_file('../../spec/fixtures/check/input.json') && close_input

      expect(last_command_started).to be_successfully_executed
      expect(last_command_started.stderr).to match(/version/)
    end
  end
end
