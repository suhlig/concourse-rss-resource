# frozen_string_literal: true
module Concourse
  module Resource
    module RSS
      class Out
        def call(input, source_directory)
          raise 'Error: No source directory given' if source_directory.nil?

          # TODO: Do something with the files in source_directory

          {
            'version'  => { 'ref' => '61cebf' },
            'metadata' => [
              { 'name' => 'commit', 'value' => '61cebf' },
              { 'name' => 'author', 'value' => 'Mick Foley' },
            ]
          }
        end
      end
    end
  end
end
