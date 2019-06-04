# frozen_string_literal: true

require 'rss'
require 'faraday'
require 'concourse/resource/rss/errors'

module Concourse
  module Resource
    module RSS
      class Feed
        attr_reader :title, :items, :last_build_date

        def initialize(url)
          response = Faraday.get(url)
          raise FeedUnavailable, "Could not fetch URL #{url}; status is #{response.status}" if response.status != 200

          feed = ::RSS::Parser.parse(response.body)
          raise FeedInvalid, url unless feed

          handle(response.headers['content-type'], feed)
        end

        def items_newer_than(version)
          items
            .select { |i| i.pubDate > version }
            .unshift(items_at(version))
            .compact
            .flatten
        end

        def items_at(version)
          items.select { |i| i.pubDate == version }
        end
      end
    end
  end
end
