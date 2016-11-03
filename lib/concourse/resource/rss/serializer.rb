# frozen_string_literal: true
module Concourse
  module Resource
    module RSS
      class Serializer
        def initialize(directory)
          @directory = directory
        end

        def serialize(item)
          %w(title link description pubDate guid).each do |attribute|
            File.write(File.join(@directory, attribute), item.send(attribute))
          end
        end
      end
    end
  end
end
