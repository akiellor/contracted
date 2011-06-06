$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'bundler'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

desc 'Runs specs'
RSpec::Core::RakeTask.new do |t|
end

Bundler::GemHelper.install_tasks

namespace :cucumber do
  desc 'Runs features'
  Cucumber::Rake::Task.new(:default) do |t|
    t.cucumber_opts = %w{--format progress}
  end

  desc 'Runs features for ci'
  Cucumber::Rake::Task.new(:ci) do |t|
    t.cucumber_opts = %w{--out out/features.html --format html}
  end
end

task :default => [:spec, :"cucumber:default"]
task :ci => [:spec, :"cucumber:ci"]
