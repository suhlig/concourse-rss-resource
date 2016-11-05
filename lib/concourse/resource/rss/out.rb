# frozen_string_literal: true
module Concourse
  module Resource
    module RSS
      class Out
        def call(input, source_directory)
          raise 'Error: No source directory given' if source_directory.nil?

          # If this resource had output, we could do something with the files in source_directory

          {
            'version'  => { 'pubDate' => 'none' },
            'metadata' => [
              { 'name' => 'comment', 'value' => 'This resource has not output.' },
            ]
          }
        end
      end
    end
  end
end
