# frozen_string_literal: true
require 'spec_helper'

describe Concourse::Resource::RSS::In do
  let(:input) { {
    'source'  => { 'foo' => 'bar' },
    'version' => { 'ref' => '61cebf' },
  } }

  context 'without destination directory' do
    let(:destination_directory) { nil }

    it 'raises an error' do
      expect {
        subject.call(input, destination_directory)
      }.to raise_error(/destination directory/)
    end
  end

  context 'with a proper destination directory' do
    let(:destination_directory) { Dir.mktmpdir }

    after do
      FileUtils.remove_entry(destination_directory)
    end

    it 'fetches the resource and responds with the fetched version and its metadata' do
      output = subject.call(input, destination_directory)

      expect(output).to eq({
        'version'  => { 'ref' => '61cebf' },
        'metadata' => [
          { 'name' => 'commit', 'value' => '61cebf' },
          { 'name' => 'author', 'value' => 'Hulk Hogan' },
        ]
      })
    end

    it 'fetches the resource and places it in the given directory' do
      fail 'TBD'
    end
  end
end

__END__

* The script must fetch the resource and place it in the given directory.
* If the desired resource version is unavailable (for example, if it was deleted), the script must error.
* The script must emit the fetched version, and may emit metadata as a list of key-value pairs.
* params is an arbitrary JSON object passed along verbatim from params on a get.
