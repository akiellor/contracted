require 'polyglot'
require 'treetop'
require 'contracted/http_description'
require 'pp'

describe HttpDescriptionParser do
  let(:description_string) { "HTTP/1.1 200 OK\n\n{'message': 'hello'}" }

  let(:description) { HttpDescriptionParser.new.parse(description_string) }

  describe "description" do
    subject { description }

    its(:headers) { subject.text_value.should == "" }
    its(:body) { subject.text_value.should == "{'message': 'hello'}" }
  end

  describe "status line" do
    subject { description.status_line }

    its(:status) { subject.text_value.should == "200" }
    its(:version) { subject.text_value.should == "1.1" }
    its(:reason) { subject.text_value.should == "OK" }
  end
end

