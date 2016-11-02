# frozen_string_literal: true
require 'spec_helper'

describe Concourse::Resource::RSS::Check do
  context 'first request (without a current version)' do
    let(:input) { { 'source' => { 'foo' => 'bar' } } }

    it 'responds with just the current version' do
      output = subject.call(input)
      expect(output).to eq([{ 'ref' => '61cebf' }])
    end
  end

  context 'consecutive request (including the current version)' do
    let(:input) do
      {
        'version' => '42',
        'source' => {
          'foo' => 'bar'
        },
      }
    end

    it 'responds with all versions since the requested one' do
      output = subject.call(input)

      expect(output).to eq([
        { 'ref' => '61cebf' },
        { 'ref' => 'd74e01' },
        { 'ref' => '7154fe' },
      ])
    end
  end
end

__END__


#
# TODO
#
# from http://concourse.ci/implementing-resources.html#resource-check:
#
# * The list may be empty, if there are no versions available at the source.
# * If the given version is already the latest, an array with that version as
#   the sole entry should be listed.
# * If your resource is unable to determine which versions are newer then the
#   given version (e.g. if it's a git commit that was push -fed over), then
#   the current version of your resource should be returned (i.e. the new HEAD).
