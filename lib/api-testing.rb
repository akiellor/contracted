require 'thin'
Thin::Logging.silent = true #silence thins loggin
require 'rest-client'
require 'active_support'
require 'rspec/expectations'
require 'api-testing/cucumber'

After do
    @peanut and @peanut.unmount
end
