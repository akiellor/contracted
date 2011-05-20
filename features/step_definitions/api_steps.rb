def loop_until &block
  loop { break if block.call; sleep(1) }
end

Given /^the "([^"]*)" app is running$/ do |app_name|
  Thread.start { Thin::Server.start('0.0.0.0', '3000') { run Kernel.const_get(app_name).new } }
  loop_until { `curl localhost:3000 &> /dev/null`; $? == 0 }
end

When /^an api client performs ([^\s]*) (.*?)$/ do |method, url|
  @response = RestClient.send(method.downcase.to_sym, "localhost:3000#{url}")
end

Then /^the json response should look like:$/ do |response_body_string|
  response_body = ActiveSupport::JSON.decode(response_body_string).map do |entry|
    [entry[0], (entry[1] == '{{...}}' ? Any.new : entry[1])]
  end

  Hash[response_body].should == ActiveSupport::JSON.decode(@response)
end

class Any
  def == other
    true
  end
end

