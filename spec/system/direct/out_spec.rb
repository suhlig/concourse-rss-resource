# frozen_string_literal: true
require 'spec_helper'
require 'system/shared/out_spec'

describe 'when `out` is executed directly', type: 'aruba' do
  let(:source_directory) { 'resource-source' }
  let(:source_file) { File.join(source_directory, 'contents') }

  before do
    create_directory(source_directory)
    run "bin/out #{source_directory}"
  end

  include_examples 'out'
end
