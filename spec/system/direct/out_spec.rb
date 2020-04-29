# frozen_string_literal: true

require 'system/shared/out_examples'

describe 'when `out` is executed directly', type: 'aruba' do
  let(:source_directory) { 'resource-source' }
  let(:source_file) { File.join(source_directory, 'contents') }

  before do
    create_directory(source_directory)
    run_command "out #{source_directory}"
  end

  include_examples 'out'
end
