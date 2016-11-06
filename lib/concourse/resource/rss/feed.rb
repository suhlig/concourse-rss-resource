# frozen_string_literal: true
require 'rss'
require 'open-uri'
require 'concourse/resource/rss/errors'

module Concourse
  module Resource
    module RSS
      class Feed
        attr_reader :title, :items, :last_build_date

        def initialize(url)
          open(url) do |rss|
            feed = ::RSS::Parser.parse(rss)
            raise FeedInvalid.new(url) unless feed

            @title = feed.channel.title.chomp
            @last_build_date = feed.channel.lastBuildDate
            @items = feed.items.map { |item| cleanup(item) }
          end
        rescue OpenURI::HTTPError => e
          raise FeedUnavailable.new(e)
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

        def items_newer_than(version)
          items.
            select { |i| i.pubDate > version }.
            unshift(items_at(version)).
            compact.
            flatten
        end

        def items_at(version)
          items.select { |i| i.pubDate == version }
        end
      end
    end
  end
end
