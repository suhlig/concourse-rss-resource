# frozen_string_literal: true

module Concourse
  module Resource
    module RSS
      class Out
        attr_reader :source_directory

        def initialize(source_directory)
          raise ArgumentError, 'No source directory given' if source_directory.nil?
          @source_directory = source_directory
        end

        def call(_source, source_directory, _params = nil)
          raise 'Error: No source directory given' if source_directory.nil?

          # If this resource had output, we could do something with
          # the files in source_directory based on source, and potentially also
          # using params

          {
            'version'  => { 'pubDate' => nil },
            'metadata' => [
              { 'name' => 'comment', 'value' => 'This resource has not output.' }
            ]
          }
        end
      end
    end
  end
end
