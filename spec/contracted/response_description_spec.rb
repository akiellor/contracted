require 'spec_helper'
require 'contracted/response_description'

describe Contracted::ResponseDescription do
  let(:description) do
    """
    HTTP/1.1 200 OK

    {'message': 'hello'}
    """
  end

  subject { Contracted::ResponseDescription.new description }

  its(:http_status) { should == '200' }
  its(:http_reason) { should == 'OK' }
  its(:http_version) { should == '1.1' }
  its(:body) { should == {'message' => 'hello'} }
  it { should be_description_of mock(:response, :code => '200', 'body' => "{'message': 'hello'}") }

end

