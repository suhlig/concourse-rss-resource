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

        private

        def handle(content_type, feed)
          case content_type
          when 'application/rss+xml', 'application/rss+xml; charset=utf-8', nil, ''
            handle_as_rss(feed)
          when 'application/atom+xml'
            handle_as_atom(feed)
          else
            raise "No handler defined for #{content_type}"
          end
        end

        def handle_as_rss(feed)
          @title = feed.channel.title.chomp
          @last_build_date = feed.channel.lastBuildDate
          @items = feed.items.map { |item| cleanup(item) }
        end

        def handle_as_atom(feed)
          @title = feed.title.content
          @last_build_date = feed.updated.content
          @items = feed.items # .map { |item| cleanup(item) }
        end

        def cleanup(item)
          item.tap do |_cleaned|
            begin
              item.title.chomp!
            rescue NoMethodError
              raise "title and description missing for item" if item.description.nil?
            end
            item.link.chomp! unless item.link.nil?
            # item.pubDate already was a parsed Time object
            raise "item is missing pubDate, so cannot be used" if item.pubDate.nil?
            begin
              item.description.chomp! while item.description[-1] == "\n"
            rescue NoMethodError
              raise "title and description missing for item" if item.title.nil?
            end
            item.guid = item.guid.nil? ? nil: item.guid.content
          end
        end
      end
    end
  end
end
