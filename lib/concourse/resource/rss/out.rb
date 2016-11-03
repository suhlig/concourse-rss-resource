# frozen_string_literal: true
module Concourse
  module Resource
    module RSS
      class Out
        def call(input, source_directory)
          raise 'Error: No source directory given' if source_directory.nil?

          # Do something with the files in source_directory

          {
            'version'  => { 'ref' => 'none' },
            'metadata' => [
              { 'name' => 'comment', 'value' => 'This resource has not output.' },
            ]
          }
        end
      end
    end
  end
end
