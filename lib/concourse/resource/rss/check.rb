# frozen_string_literal: true

require 'concourse/resource/rss/feed'

#
# Not sure what to do with this scenario from http://concourse-ci.org/implementing-resources.html#resource-check:
#
#   If your resource is unable to determine which versions are newer then the
#   given version (e.g. if it's a git commit that was push -fed over), then
#   the current version of your resource should be returned (i.e. the new HEAD).
#
module Concourse
  module Resource
    module RSS
      class Check
        def call(source, version)
          @feed = Feed.new(source.fetch('url'))

          if version&.key?('pubDate')
            at(version)
          else
            first
          end
        end

        private

        def at(version)
          version = Time.parse(version.fetch('pubDate'))

          @feed.items_newer_than(version)
               .sort_by(&:pubDate)
               .map { |i| { 'pubDate' => i.pubDate } }
               .uniq
        end

        def first
          return [] if @feed.items.empty?
          [{ 'pubDate' => @feed.last_item_date }]
        end
      end
    end
  end
end
