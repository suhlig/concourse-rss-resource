# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

def fixture(path)
  File.expand_path("fixtures/#{path}", __dir__)
end

require 'aruba/rspec'
