require 'thin'
Thin::Logging.silent = true #silence thins loggin
require 'rest-client'
require 'active_support'
require 'rspec/expectations'
require 'api-testing/cucumber'

After do
    @server_thread and @server_thread.terminate
end
