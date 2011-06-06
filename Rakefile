$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'bundler'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rspec/core/formatters/html_formatter'
require 'cucumber/formatter/html'

Bundler::GemHelper.install_tasks

namespace :ci do
  desc 'Runs specs'
  RSpec::Core::RakeTask.new do |t|
    FileUtils.makedirs('out')
    t.rspec_opts = %w{--no-color --format progress --format html --out out/examples.html}
  end

  desc 'Runs features for ci'
  Cucumber::Rake::Task.new do |t|
    FileUtils.makedirs('out')
    t.cucumber_opts = %w{--no-color --format progress --format html --out out/features.html}
  end 
end

namespace :local do
  desc 'Runs specs'
  RSpec::Core::RakeTask.new do |t|
  end

  desc 'Runs features'
  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format progress}
  end
end

task :default => [:"local:spec", :"local:cucumber"]
