require 'contracted/application'
require 'contracted/cucumber'

class Any
  def == other
    true
  end
end

Contracted::JsonResponseDescription.register_replacement '{{...}}', Any.new

After do
  Contracted.app and Contracted.app.unmount
end
