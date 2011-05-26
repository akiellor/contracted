require 'contracted/application'
require 'contracted/response_description'
require 'contracted/cucumber'

class Any
  def == other
    true
  end
end

Contracted::ResponseDescription.register_replacement '{{...}}', Any.new

After do
  Contracted.app and Contracted.app.unmount
end
