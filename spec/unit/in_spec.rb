# frozen_string_literal: true
require 'spec_helper'

describe Concourse::Resource::RSS::In do
  let(:input) { {
    'source'  => { 'foo' => 'bar' },
    'version' => { 'ref' => '61cebf' },
  } }

  let(:destination_directory) { Dir.mktmpdir }

  after do
    FileUtils.remove_entry(destination_directory) if destination_directory
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

  xit 'fetches the resource and places it in the given directory' do
  end

  xit 'emits the fetched version' do
  end

  xit 'emits metadata as a list of key-value pairs' do
  end

  xit 'accepts params passed as an arbitrary JSON object' do
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
