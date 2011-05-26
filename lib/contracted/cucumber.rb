Given /^the "([^"]*)" app is running$/ do |app_name|
  app = Kernel.const_get(app_name).new
  Contracted.mount app
end

When /^an api client performs (GET|POST|PUT|DELETE) ([^\s]+)$/ do |method, url|
  Contracted.app.send(method.downcase.to_sym, url, "", {})
end

When /^an api client performs (POST|PUT) ([^\s]+) with json body:$/ do |method, url, body|
  Contracted.app.send(method.downcase.to_sym, url, body, {:content_type => 'application/json'})
end

Then /^the json response should look like:$/ do |response_body_string|
  Contracted::JsonResponseDescription.new(response_body_string).should be_description_of Contracted.app.last
end

