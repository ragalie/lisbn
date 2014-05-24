#!/usr/bin/env rake
require "bundler/gem_tasks"

Dir["tasks/**/*.rake"].each { |ext| load ext }

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
