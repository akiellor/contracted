require 'contracted'
require 'active_support'

After do
  Contracted.app and Contracted.app.unmount
end

Given /^the "([^"]*)" app is running$/ do |app_name|
  app = Kernel.const_get(app_name).new
  Contracted.mount app, '9898'
end

When /^an api client performs (GET|POST|PUT|DELETE) ([^\s]+)$/ do |method, url|
  Contracted.app.send(method.downcase.to_sym, url, "", {})
end

When /^an api client performs (POST|PUT) ([^\s]+) with json body:$/ do |method, url, body|
  Contracted.app.send(method.downcase.to_sym, url, body, {:content_type => 'application/json'})
end

Then /^the json response should look like:$/ do |response_body_string|
  Contracted::ResponseDescription.new(response_body_string).should be_description_of Contracted.app.last
end

Then /^the json response body should look like:$/ do |response_body_string|
  JsonDescriptionParser.new.parse(response_body_string).value.should == ActiveSupport::JSON.decode(Contracted.app.last.body)
end
