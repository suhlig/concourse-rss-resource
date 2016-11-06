# frozen_string_literal: true
require 'concourse/resource/rss/feed'
require 'concourse/resource/rss/serializer'
require 'concourse/resource/rss/errors'

module Concourse
  module Resource
    module RSS
      class In
        def call(source, version, destination_directory, params=nil)
          raise 'No destination directory given' if destination_directory.nil?

          version = Time.parse(version.fetch('pubDate'))
          url = source.fetch('url')

          feed = Feed.new(url)
          item = feed.items_at(version).first
          raise VersionUnavailable.new(version, source) if item.nil?

          Serializer.new(destination_directory).serialize(item)

          {
            'version'  => { 'pubDate' => item.pubDate },
            'metadata' => [
              { 'name' => 'title', 'value' => item.title },
              { 'name' => 'description', 'value' => item.description },
            ]
          }
        end
      end
    end
  end
end
