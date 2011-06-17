require 'json'
require 'contracted'

describe JsonDescriptionParser do
  let(:parser) { JsonDescriptionParser.new } 
  let(:description) { parser.parse(description_string) }

  subject { description.value }

  context "a standard json representation" do
    let(:description_string) { '{"message": "hello"}' }
    
    describe "the description" do
      it { should be_match json('{"message": "hello"}') }
      it { should_not be_match json('{"message": "goodbye"}') }
    end
  end

  context "with a key wildcard" do
    let(:description_string) { '{"message": "hello", ...}' }

    describe "the description" do
      it { should be_match json('{"message": "hello"}')  }

      it { should be_match json('{"message": "hello", "type": "greeting"}') }
      it { should_not be_match json('{"message": "goodbye"}') }
      it { should_not be_match json('{"type": "greeting"}') }
    end
  end

  context "with a nested wildcard" do
    let(:description_string) { '{"message": {"type": "greeting", "text": ...}}' }

    describe "the description" do
      it { should be_match json('{"message": {"type": "greeting", "text": "hello"}}') }
    end
  end

  context "with weird whitespace" do
    let(:description_string) { %Q{{\t"message":          {"type":\n "greeting", \n\r "text": ...}}} }

    describe "the description" do
      it { should be_match json('{"message": {"type": "greeting", "text": "hello"}}') }
    end
  end

  context "with array in heirarchy" do
    let(:description_string) { '[1,2,3,4,{"key": ...}]' }

    it { should be_match json('[1,2,3,4,{"key": "value"}]') }
  end

  context "with wildcard" do
    let(:description_string) { '...' }

    it { should be_match 1 }
    it { should be_match({}) }
    it { should be_match [1,2,3] }
  end

  context "with a wildcard value" do
    let(:description_string) { '{"message": ..., "type": "greeting" }' }

    describe "the description" do
      it { should be_match json('{"message": "hello", "type": "greeting" }') }
      it { should be_match json('{"message": "goodbye", "type": "greeting" }') }
      it { should_not be_match json('{"msg": "hello", "type": "greeting" }') }
      it { should_not be_match json('{"message": "hello"}') }
      it { should_not be_match json('{"type": "greeting"}') }
    end
  end

  context "with multiple key wildcard" do
    let(:description_string) { '{"message": ... , ...}' }

    describe "the description" do
      it { should be_match json('{"message": "hello"}')  }
      it { should be_match json('{"message": "hello", "type": "greeting"}') }
      it { should be_match json('{"message": "hello", "type": "greeting", "length": "150"}') }
      it { should be_match json('{"message": "goodbye"}') }
      it { should_not be_match json('{"type": "greeting"}') }
    end
  end

  context "with single quotes" do
    let(:description_string) { "{'message': 'hello'}" }

    subject { proc { parser.parse(description_string) } }

    it {
      should raise_error(
         Contracted::MalformedJsonDescription, 
         <<-eos
Expected one of ", ..., } at line 1, column 2 (byte 2) after {

{'message': 'hello'}
 ^
         eos
      )
    }
  end

  def json json_string
    JSON.parse json_string
  end

  RSpec::Matchers.define :be_match do |json|
    match do |description|
      description.match? json
    end

    failure_message_for_should do
      "Expected json to match but didn't"
    end

    failure_message_for_should_not do
      "Expected json not to match but did"
    end
  end
end

