# frozen_string_literal: true

require 'system/shared/check_examples'

describe 'when `check` is executed directly', type: 'aruba' do
  before do
    run_command 'bin/check'
  end

  include_examples 'check'
end
