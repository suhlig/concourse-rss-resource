# frozen_string_literal: true
module Concourse
  module Resource
    module RSS
      class In
        def call(input, destination_directory)
          raise 'Error: No destination directory given' if destination_directory.nil?

          destination_file = File.join(destination_directory, 'version')
          version = input['version']

          File.write(destination_file,
            JSON.generate({
                'version' => version
              }))

          {
            'version'  => version,
            'metadata' => [
              { 'name' => 'commit', 'value' => '61cebf' },
              { 'name' => 'author', 'value' => 'Hulk Hogan' },
            ]
          }
        end
      end
    end
  end
end
