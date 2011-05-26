$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../features/support')

RSpec.configure do |config|
  config.mock_with :rspec
end
