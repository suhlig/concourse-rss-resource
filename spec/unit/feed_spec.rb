# frozen_string_literal: true

require 'concourse/resource/rss/feed'

describe Concourse::Resource::RSS::Feed do
  subject { Concourse::Resource::RSS::Feed.new(url) }
  let(:url) { 'https://www.postgresql.org/versions.rss' }
  let(:feed_body) { fixture('feed/postgres-versions.rss') }
  let(:content_type) { 'application/rss+xml' }

  before do
    stub_request(:get, url).to_return(
      status: 200,
      body: feed_body,
      headers: {'Content-Type' => content_type}
    )
  end
Concourse::Resource::RSS::Feed
  context 'with a valid feed' do
    it 'has the title' do
      expect(subject.title).to eq('PostgreSQL latest versions')
    end

    it 'has the last build date' do
      expect(subject.last_build_date).to eq(Time.parse('Thu, 28 Oct 2016 00:00:00 +0000'))
    end

    it 'has the last item date' do
      expect(subject.last_item_date).to eq(Time.parse('Thu, 27 Oct 2016 00:00:00 +0000'))
    end

    it 'has a number of items' do
      expect(subject.items).to_not be_empty
      expect(subject.items).to have(20).items
    end

    it 'has a first item with title' do
      first = subject.items.first
      expect(first.title).to eq('9.6.1')
    end

    it 'has a first item with link' do
      first = subject.items.first
      expect(first.link).to eq('https://www.postgresql.org/docs/9.6/static/release-9-6-1.html')
    end

    it 'has a first item with description' do
      first = subject.items.first
      expect(first.description).to eq('9.6.1 is the latest release in the 9.6 series.')
    end

    it 'has a first item with pubDate' do
      first = subject.items.first
      expect(first.pubDate).to eq(Time.parse('Thu, 27 Oct 2016 00:00:00 +0000'))
    end

    it 'has a first item with guid' do
      first = subject.items.first
      expect(first.guid).to eq('https://www.postgresql.org/docs/9.6/static/release-9-6-1.html')
    end
  end

  context 'with an empty feed' do
    let(:feed_body) { '' }

    it 'complains if the content is empty' do
      expect { subject } .to raise_error(/No root element/)
    end
  end

  context 'with a feed that is temporarily unavailable' do
    before do
      stub_request(:get, url).to_return(
        status: 404
      )
    end

    it 'returns an empty response' do
      expect { subject.items }.to raise_error(/404/)
    end
  end
  context 'with a feed without one of the allowed" Content-Type headers' do
    context 'with a valid rss feed body' do
      let(:url) { 'https://www.postgresql.org/versions.rss' }
      let(:feed_body) { fixture('feed/postgres-versions.rss') }
      before do
        stub_request(:get, url).to_return(
          body: feed_body,
          headers: {'Content-Type' => "text/xml"}
        )
      end
      it 'has the title' do
        expect(subject.title).to eq('PostgreSQL latest versions')
      end
    end
    context 'with a valid atom feed body' do
      let(:url) { 'https://github.com/hashicorp/vagrant/releases.atom' }
      let(:feed_body) { fixture('feed/releases.atom') }
      before do
        stub_request(:get, url).to_return(
          body: feed_body,
          headers: {'Content-Type' => "text/xml"}
        )
      end
      it 'has the title' do
        expect(subject.title).to eq('Release notes from vagrant')
      end
    end
    context 'with a non-feed, valid XML body' do
      let(:url) { 'https://example.com/not/a/feed.xml' }
      let(:feed_body) { fixture('feed/dummy.xml') }
      before do
        stub_request(:get, url).to_return(
          body: feed_body,
          headers: {'Content-Type' => "text/xml"}
        )
      end
      it 'continues to fail RSS parsing' do
        expect { subject } .to raise_error(/prefix <> doesn't associate uri/)
      end
    end
  end
end
