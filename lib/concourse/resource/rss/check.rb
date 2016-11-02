# frozen_string_literal: true
module Concourse
  module Resource
    module RSS
      class Check
        def call(input)
          output = [
            { 'ref' => '61cebf' },
          ]

          if input['version']
            output << { 'ref' => 'd74e01' }
            output << { 'ref' => '7154fe' }
          end

          output
        end
      end
    end
  end
end
