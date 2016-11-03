# frozen_string_literal: true
require 'spec_helper'
require 'system/shared/check_spec'

describe 'when `check` is executed directly', type: 'aruba' do
  before do
    run 'bin/check'
  end

  include_examples 'check'
end
