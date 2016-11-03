# frozen_string_literal: true
require 'spec_helper'

describe Concourse::Resource::RSS::Out do
  let(:input) {
    {
      'params' => { 'branch' => 'develop', 'repo' => 'some-repo' },
      'source' => { 'uri' => 'git@...', 'private_key' => '...' },
    }
  }

  let(:source_directory) { Dir.mktmpdir }

  after do
    FileUtils.remove_entry(source_directory) if source_directory
  end

  xit 'pushes the resource from the contents of the source directory' do
  end

  it 'emits the resulting version of the resource' do
    output = subject.call(input, source_directory)

    expect(output).to include('version')
    expect(output['version']).to include('timestamp')
  end

  it 'emits the resulting meta data of the resource' do
    output = subject.call(input, source_directory)

    expect(output).to_not be_empty
    expect(output).to include('metadata')
    expect(output['metadata']).to include({ 'name' => 'commit', 'value' => '61cebf' })
    expect(output['metadata']).to include({ 'name' => 'author', 'value' => 'Mick Foley' })
  end

  context 'without source directory' do
    let(:source_directory) { nil }

    it 'raises an error' do
      expect {
        subject.call(input, source_directory)
      }.to raise_error(/source directory/)
    end
  end
end
