$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'bundler'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

desc 'Runs specs'
RSpec::Core::RakeTask.new do |t|
end

Bundler::GemHelper.install_tasks

desc 'Runs features'
Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format pretty}
end

task :default => [:spec, :cucumber]
