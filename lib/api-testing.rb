require 'thin'
Thin::Logging.silent = true #silence thins loggin
require 'rest-client'
require 'active_support'
require 'rspec/expectations'
require 'api-testing/cucumber'

JsonResponseDescriptor.register_replacement '{{...}}', Any.new

After do
    @peanut and @peanut.unmount
end
