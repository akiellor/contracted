require 'contracted/application'
require 'contracted/response_description'
require 'contracted/replacement'
require 'contracted/cucumber'

After do
  Contracted.app and Contracted.app.unmount
end
