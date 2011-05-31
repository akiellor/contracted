require 'active_support'
require 'contracted'

describe JsonDescriptionParser do
  let(:parser) { JsonDescriptionParser.new } 
  let(:description) { parser.parse(description_string) }

  subject { description.value }

  context "a standard json representation" do
    let(:description_string) { '{"message": "hello"}' }
    
    describe "the description" do
      it { should == json('{"message": "hello"}') }
      it { should_not == json('{"message": "goodbye"}') }
    end
  end

  context "with a key wildcard" do
    let(:description_string) { '{"message": "hello", ...}' }

    describe "the description" do
      it { should == json('{"message": "hello"}')  }
      it { should == json('{"message": "hello", "type": "greeting"}') }
      it { should_not == json('{"message": "goodbye"}') }
      it { should_not == json('{"type": "greeting"}') }
    end
  end

  context "with a wildcard value" do
    let(:description_string) { '{"message": ..., "type": "greeting" }' }

    describe "the description" do
      it { should == json('{"message": "hello", "type": "greeting" }') }
      it { should == json('{"message": "goodbye", "type": "greeting" }') }
      it { should_not == json('{"msg": "hello", "type": "greeting" }') }
      it { should_not == json('{"message": "hello"}') }
      it { should_not == json('{"type": "greeting"}') }
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
    ActiveSupport::JSON.decode json_string
  end
end

