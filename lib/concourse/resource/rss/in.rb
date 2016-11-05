# frozen_string_literal: true
require 'concourse/resource/rss/feed'
require 'concourse/resource/rss/serializer'

module Concourse
  module Resource
    module RSS
      class In
        def call(input, destination_directory)
          raise 'No destination directory given' if destination_directory.nil?
          version = Time.parse(input['version'].fetch('pubDate'))
          url = input['source'].fetch('url')

          feed = Feed.new(url)
          item = feed.items_at(version).first
          raise "Could not find the desired item with version #{version} in #{url}" if item.nil?

          Serializer.new(destination_directory).serialize(item)

          {
            'version'  => { 'pubDate' => version },
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
