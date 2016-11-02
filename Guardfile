# frozen_string_literal: true
guard 'bundler' do
  watch('Gemfile')
end

guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)
  watch(%r{^spec/shared/.+_spec\.rb$}){ "spec" }
  watch(%r{^bin/(.+)$}) { |m| "spec/unit/#{m[1]}_spec.rb" }

  dsl.watch_spec_files_for(dsl.ruby.lib_files)
end

__END__

watch('spec/spec_helper.rb')                        { "spec" }
watch('config/routes.rb')                           { "spec/routing" }
watch('app/controllers/application_controller.rb')  { "spec/controllers" }
watch(%r{^spec/.+_spec\.rb$})
watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
