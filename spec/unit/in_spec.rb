# frozen_string_literal: true
require 'spec_helper'

describe Concourse::Resource::RSS::In do
  let(:destination_directory) { Dir.mktmpdir }
  let(:pub_date) { 'Thu, 27 Oct 2016 00:00:00 +0000' }

  before do
    stub_request(:get, 'https://www.postgresql.org/versions.rss').to_return(
      status: 200,
      body: File.read(fixture('feed/postgres-versions.rss'))
    )
  end

  after do
    FileUtils.remove_entry(destination_directory) if destination_directory
  end

  let(:input) do
    {
      'source'  => { 'url' => 'https://www.postgresql.org/versions.rss' },
      'version' => { 'pubDate' => pub_date },
    }
  end

  context 'the requested version of the resource is available' do
    it 'responds with the fetched version' do
      output = subject.call(input, destination_directory)

      expect(output).to include({
        'version' => { 'pubDate' => Time.parse(pub_date) },
        })
    end

    it 'responds with metadata of the fetched version' do
      output = subject.call(input, destination_directory)

      expect(output).to include({
        'metadata' => [
          { 'name' => 'title', 'value' => '9.6.1' },
          { 'name' => 'description', 'value' => '9.6.1 is the latest release in the 9.6 series.' },
        ]
        })
    end

    it "places the resource's title in the destination directory" do
      subject.call(input, destination_directory)

      title = Pathname(destination_directory).join('title')
      expect(title).to be
      expect(title.read).to eq('9.6.1')
    end

    it "places the resource's link in the destination directory" do
      subject.call(input, destination_directory)

      link = Pathname(destination_directory).join('link')
      expect(link).to be
      expect(link.read).to eq('https://www.postgresql.org/docs/9.6/static/release-9-6-1.html')
    end

    it "places the resource's description in the destination directory" do
      subject.call(input, destination_directory)

      description = Pathname(destination_directory).join('description')
      expect(description).to be
      expect(description.read).to eq('9.6.1 is the latest release in the 9.6 series.')
    end

    it "places the resource's pubDate in the destination directory" do
      subject.call(input, destination_directory)

      pub_date = Pathname(destination_directory).join('pubDate')
      expect(pub_date).to be
      expect(pub_date.read).to eq('Thu, 27 Oct 2016 00:00:00 +0000')
    end

    it "places the resource's guid in the destination directory" do
      subject.call(input, destination_directory)

      guid = Pathname(destination_directory).join('guid')
      expect(guid).to be
      expect(guid.read).to eq('https://www.postgresql.org/docs/9.6/static/release-9-6-1.html')
    end
  end

  it 'accepts params passed as an arbitrary JSON object' do
    input.merge({ 'params' => { 'some' => 'thing', 'else' => 42 } })
    output = subject.call(input, destination_directory)
    expect(output).to include('version')
  end

  context 'without destination directory' do
    let(:destination_directory) { nil }

    it 'raises an error' do
      expect {
        subject.call(input, destination_directory)
      }.to raise_error(/destination directory/)
    end
  end

  context 'the desired resource version is unavailable' do
    xit 'raises an error' do
    end
  end
end
