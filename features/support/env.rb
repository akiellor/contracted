require 'thin'
Thin::Logging.silent = true #silence thins loggin
require 'rest-client'
require 'active_support'
require 'rspec/expectations'
require 'features/support/apps/hello_world'


After do
  @server_thread and @server_thread.terminate
end

