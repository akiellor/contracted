require 'thin'
require 'rest-client'
require 'active_support'
require 'rspec/expectations'
require 'api-testing/cucumber'

Thin::Logging.silent = true #silence thins loggin

Contracted::JsonResponseDescriptor.register_replacement '{{...}}', Any.new

After do
  Contracted.app and Contracted.app.unmount
end
