$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'bundler'
require 'cucumber/rake/task'

Bundler::GemHelper.install_tasks
Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format pretty}
end

task :default => :cucumber
