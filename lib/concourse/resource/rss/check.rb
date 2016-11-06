# frozen_string_literal: true
require 'concourse/resource/rss/feed'

#
# Not sure what to do with this scenario from http://concourse.ci/implementing-resources.html#resource-check:
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
          url = source.fetch('url')

          begin
            feed = Feed.new(url)
          rescue InvalidFeed => e
            warn e.message
            return []
          end

          if version && version.key?('pubDate')
            version = Time.parse(version.fetch('pubDate'))

            feed.items_newer_than(version).
              sort_by(&:pubDate).
              map { |i| { 'pubDate' => i.pubDate } }.
              uniq
          else
            return [] if feed.items.empty?
            [{ 'pubDate' => feed.items.first.pubDate }]
          end
        end
      end
    end
  end
end
