# frozen_string_literal: true

require 'concourse/resource/rss/errors'

describe Concourse::Resource::RSS::In do
  subject { Concourse::Resource::RSS::In.new(destination_directory) }
  let(:destination_directory) { Dir.mktmpdir }
  let(:desired_pub_date) { 'Thu, 27 Oct 2016 00:00:00 +0000' }

  before do
    stub_request(:get, 'https://www.postgresql.org/versions.rss').to_return(
      status: 200,
      body: fixture('feed/postgres-versions.rss')
    )
  end

  after do
    FileUtils.remove_entry(destination_directory) if destination_directory
  end

  let(:source) { { 'url' => 'https://www.postgresql.org/versions.rss' } }
  let(:version) { { 'pubDate' => desired_pub_date } }

  context 'the requested version of the resource is available' do
    it 'responds with the fetched version' do
      output = subject.call(source, version)

      expect(output).to include(
        'version' => { 'pubDate' => Time.parse(desired_pub_date) }
      )
    end

    it 'responds with metadata of the fetched version' do
      output = subject.call(source, version)

      expect(output).to include(
        'metadata' => [
          { 'name' => 'title', 'value' => '9.6.1' },
          { 'name' => 'description', 'value' => '9.6.1 is the latest release in the 9.6 series.' }
        ]
      )
    end

    it "places the resource's title in the destination directory" do
      subject.call(source, version)

      title = Pathname(destination_directory).join('title')
      expect(title).to be
      expect(title.read).to eq('9.6.1')
    end

    it "places the resource's link in the destination directory" do
      subject.call(source, version)

      link = Pathname(destination_directory).join('link')
      expect(link).to be
      expect(link.read).to eq('https://www.postgresql.org/docs/9.6/static/release-9-6-1.html')
    end

    it "places the resource's description in the destination directory" do
      subject.call(source, version)

      description = Pathname(destination_directory).join('description')
      expect(description).to be
      expect(description.read).to eq('9.6.1 is the latest release in the 9.6 series.')
    end

    it "places the resource's pubDate in the destination directory" do
      subject.call(source, version)

      pub_date = Pathname(destination_directory).join('pubDate')
      expect(pub_date).to be
      expect(pub_date.read).to eq('Thu, 27 Oct 2016 00:00:00 +0000')
    end

    it "places the resource's guid in the destination directory" do
      subject.call(source, version)

      guid = Pathname(destination_directory).join('guid')
      expect(guid).to be
      expect(guid.read).to eq('https://www.postgresql.org/docs/9.6/static/release-9-6-1.html')
    end
  end

  it 'accepts params passed as an arbitrary JSON object' do
    params = { 'params' => { 'some' => 'thing', 'else' => 42 } }
    output = subject.call(source, version, params)
    expect(output).to include('version')
  end

  context 'without destination directory' do
    let(:destination_directory) { nil }

    it 'raises an error' do
      expect do
        subject.call(source, version)
      end.to raise_error(/destination directory/)
    end
  end

  context 'the desired resource version is unavailable' do
    let(:desired_pub_date) { 'Thu, 27 Oct 2046 00:00:00 +0000' }

    it 'raises an error' do
      expect do
        subject.call(source, version)
      end.to raise_error(Concourse::Resource::RSS::VersionUnavailable)
    end
  end
end
