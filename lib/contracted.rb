require 'thin'
require 'rest-client'
require 'active_support'
require 'rspec/expectations'
require 'contracted/application'
require 'contracted/cucumber'

Thin::Logging.silent = true #silence thins loggin

class Any
  def == other
    true
  end
end

Contracted::JsonResponseDescriptor.register_replacement '{{...}}', Any.new

After do
  Contracted.app and Contracted.app.unmount
end
