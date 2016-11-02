# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'aruba/rspec'
require 'rspec/json_matcher'

RSpec.configuration.include RSpec::JsonMatcher
