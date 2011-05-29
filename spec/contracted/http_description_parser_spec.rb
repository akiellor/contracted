require 'polyglot'
require 'treetop'
require 'contracted/http_description'
require 'contracted/http_description/matchers'

describe HttpDescriptionParser do
  let(:description) { HttpDescriptionParser.new.parse(description_string) }

  context "no headers as part of description" do
    let(:description_string) { "HTTP/1.1 200 OK\n\n{'message': 'hello'}" }
    
    describe "description" do
      subject { description }

      its(:headers) { subject.matcher.should be_an_instance_of Contracted::HttpDescription::SameHeadersMatcher }
      its(:headers) { subject.values.should == [] }
      its(:headers) { subject.text_value.should == '' }
      its(:body) { subject.text_value.should == "{'message': 'hello'}" }
    end

    describe "status line" do
      subject { description.status_line }

      its(:status) { subject.text_value.should == "200" }
      its(:version) { subject.text_value.should == "1.1" }
      its(:reason) { subject.text_value.should == "OK" }
    end
  end

  context "wildcard header in description" do
    let(:description_string) { "HTTP/1.1 200 OK\nContent-Type: application/json\n...\n\n{'message': 'hello'}" }

    describe "description" do
      subject { description }

      its(:headers) { subject.values.should == [{'Content-Type' => 'application/json'}, '...'] }
      its(:headers) { subject.matcher.should be_an_instance_of Contracted::HttpDescription::IncludeHeadersMatcher }
    end
  end
end

