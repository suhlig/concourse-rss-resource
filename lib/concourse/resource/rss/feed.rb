# frozen_string_literal: true
require 'rss'
require 'open-uri'

module Concourse
  module Resource
    module RSS
      class Feed
        attr_reader :title, :items, :last_build_date

        def initialize(url)
          open(url) do |rss|
            feed = ::RSS::Parser.parse(rss)
            @title = feed.channel.title.chomp
            @last_build_date = feed.channel.lastBuildDate
            @items = feed.items.map { |item| cleanup(item) }
          end
        end

        def cleanup(item)
          item.tap do |cleaned|
            item.title.chomp!
            item.link.chomp!
            # item.pubDate already was a parsed Time object
            item.description.chomp! while "\n" == item.description[-1]
            item.guid = item.guid.content
          end
        end
      end
    end
  end
end
