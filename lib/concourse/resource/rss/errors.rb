# frozen_string_literal: true
module Concourse
  module Resource
    module RSS
      class InvalidFeed < StandardError
        def initialize(url)
          super("Could not parse contents of #{url}")
        end
      end
    end
  end
end
