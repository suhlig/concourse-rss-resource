# frozen_string_literal: true
require 'spec_helper'

describe Concourse::Resource::RSS::Check do
  let(:feed_body) { File.read(fixture('feed/postgres-versions.rss')) }

  before do
    stub_request(:get, 'https://www.postgresql.org/versions.rss').to_return(
      status: 200,
      body: feed_body
    )
  end

  context 'there is no newer version than the current one' do
    let(:current_version_pub_date) { 'Thu, 27 Oct 2016 00:00 +0000' }

    context 'first request (without a current version)' do
      let(:input) do
        { 'source' => { 'url' => 'https://www.postgresql.org/versions.rss' } }
      end

      it 'responds with just the current version' do
        output = subject.call(input)
        expect(output).to eq([{ 'pubDate' => Time.parse(current_version_pub_date) }])
      end
    end

    context 'consecutive request (including the current version)' do
      let(:input) do
        {
          'source' => { 'url' => 'https://www.postgresql.org/versions.rss' },
          'version' => { 'pubDate' => current_version_pub_date },
        }
      end

      it 'responds with just the current version' do
        output = subject.call(input)
        expect(output).to eq([{ 'pubDate' => Time.parse(current_version_pub_date) }])
      end
    end
  end

  context 'there are newer versions than the current one' do
    context 'first request (without a current version)' do
      let(:input) do
        { 'source' => { 'url' => 'https://www.postgresql.org/versions.rss' } }
      end

      it 'responds with just the current version' do
        output = subject.call(input)
        expect(output).to eq([{ 'pubDate' => Time.parse('2016-10-27 00:00 +0000') }])
      end
    end

    context 'consecutive request (including the current version)' do
      let(:current_version_pub_date) { 'Thu, 24 Jul 2014 00:00 +0000' }

      let(:input) do
        {
          'source' => { 'url' => 'https://www.postgresql.org/versions.rss' },
          'version' => { 'pubDate' => current_version_pub_date },
        }
      end

      it 'responds with all versions since the requested one' do
        output = subject.call(input)

        #
        # 2016-10-27 is a bit special because multiple versions were released
        # on this day. The resource acually collapses all of them and returns
        # only the latest.
        #
        expect(output).to eq([
          { 'pubDate' => Time.parse('2016-10-27 00:00 +0000') },  # 9.6.1
          { 'pubDate' => Time.parse('2015-10-08 00:00 +0000') },  # 9.0.23
          { 'pubDate' => Time.parse('2014-07-24 00:00 +0000') },  # 8.4.22
        ])
      end
    end
  end

  context 'there are no versions available at the source' do
    let(:feed_body) { File.read(fixture('feed/empty.rss')) }
    let(:current_version_pub_date) { 'Thu, 27 Oct 2016 00:00 +0000' }

    context 'first request (without a current version)' do
      let(:input) do
        { 'source' => { 'url' => 'https://www.postgresql.org/versions.rss' } }
      end

      it 'responds with an empty list' do
        output = subject.call(input)
        expect(output).to be_empty
      end
    end

    context 'consecutive request (including the current version)' do
      let(:input) do
        {
          'source' => { 'url' => 'https://www.postgresql.org/versions.rss' },
          'version' => { 'pubDate' => current_version_pub_date },
        }
      end

      it 'responds with an empty list' do
        output = subject.call(input)
        expect(output).to be_empty
      end
    end
  end
end
