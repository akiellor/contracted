require 'spec_helper'
require 'contracted/response_description'
require 'contracted/replacement'

describe Contracted::ResponseDescription do
  subject { Contracted::ResponseDescription.new description }

  context "simple json object description body" do
    let(:description) do
      """
      HTTP/1.1 200 OK

      {'message': 'hello'}
      """
    end

    its(:http_status) { should == '200' }
    its(:http_reason) { should == 'OK' }
    its(:http_version) { should == '1.1' }
    its(:body) { should == {'message' => 'hello'} }
    it { should be_description_of mock(:response, :code => '200', 'body' => "{'message': 'hello'}") }
 end

  context "simple array description body" do
    let(:description) do
      """
      HTTP/1.1 200 OK

      [1,2,3,4,5]
      """
    end
    
    its(:http_status) { should == '200' }
    its(:http_reason) { should == 'OK' }
    its(:http_version) { should == '1.1' }
    its(:body) { should == [1,2,3,4,5] }
    it { should be_description_of mock(:response, :code => '200', 'body' => "[1,2,3,4,5]") }
  end

  context "json object with {{...}} replacement" do
    let(:description) do
      """
      HTTP/1.1 200 OK

      {'message': '{{...}}'}
      """
    end

    it { should be_description_of mock(:response, :code => 200, 'body' => "{'message': 'hello'}") }
    it { should be_description_of mock(:response, :code => 200, 'body' => "{'message': 'goodbye'}") }
    it { should_not be_description_of mock(:response, :code => 200, 'body' => "{'anotherKey': 'anotherValue'}") }
    it { should_not be_description_of mock(:response, :code => 200, 'body' => "{'anotherKey': 'anotherValue', 'message': 'something'}") }
  end

  context "json object with nested {{...}} replacement" do
    let(:description) do
      """
      HTTP/1.1 200 OK

      {
        'message': {
          'type': 'greeting',
          'text': '{{...}}'
        }
      }
      """
    end

    it { should be_description_of mock(:response, :code => 200, 'body' => "{'message': {'type': 'greeting', 'text': 'hello'}}") }

    it { should be_description_of mock(:response, :code => 200, 'body' => "{'message': {'type': 'greeting', 'text': 'goodbye'}}") }
  end
end

