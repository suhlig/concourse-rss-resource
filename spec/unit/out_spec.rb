# frozen_string_literal: true

describe Concourse::Resource::RSS::Out do
  subject { Concourse::Resource::RSS::Out.new(source_directory) }
  let(:source_directory) { Dir.mktmpdir }
  let(:source) { { 'uri' => 'git@...', 'private_key' => '...' } }
  let(:params) { { 'branch' => 'develop', 'repo' => 'some-repo' } }

  after do
    FileUtils.remove_entry(source_directory) if source_directory
  end

  it 'pushes the resource from the contents of the source directory' do
    skip "This resource has no output, so we don't push anything"
  end

  it 'emits the resulting version of the resource' do
    output = subject.call(source, source_directory, params)

    expect(output).to include('version')
    expect(output['version']).to include('pubDate' => nil)
  end

  it 'emits the resulting meta data of the resource' do
    output = subject.call(source, source_directory, params)

    expect(output).to_not be_empty
    expect(output).to include('metadata')
    expect(output['metadata']).to include('name' => 'comment', 'value' => 'This resource has not output.')
  end

  context 'without source directory' do
    let(:source_directory) { nil }

    it 'raises an error' do
      expect do
        subject.call(source, source_directory, params)
      end.to raise_error(/source directory/)
    end
  end
end
