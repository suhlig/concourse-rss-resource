# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'concourse/resource/rss'

require 'aruba/rspec'
require 'rspec/json_matcher'
require 'rspec/collection_matchers'
require 'webmock/rspec'

WebMock.disable_net_connect!
RSpec.configuration.include RSpec::JsonMatcher

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), 'fixtures', name))
end
