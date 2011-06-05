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

  context "with a nested wildcard" do
    let(:description_string) { '{"message": {"type": "greeting", "text": ...}}' }

    describe "the description" do
      it { should == json('{"message": {"type": "greeting", "text": "hello"}}') }
    end
  end

  context "with weird whitespace" do
    let(:description_string) { %Q{{\n"message":          {"type":\n "greeting", \n\n "text": ...}}} }

    describe "the description" do
      it { should == json('{"message": {"type": "greeting", "text": "hello"}}') }
    end
  end

  context "with array in heirrachy" do
    let(:description_string) { '[1,2,3,4,{"key": ...}]' }

    it { should == json('[1,2,3,4,{"key": "value"}]') }
  end

  context "with empty string" do
    let(:description_string) { '""' }

    it { should == json('""') }
  end

  context "with wildcard" do
    let(:description_string) { '...' }

    it { should == 1 }
    it { should == {} }
    it { should == [1,2,3] }
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

  context "with multiple key wildcard" do
    let(:description_string) { '{"message": ... , ...}' }

    describe "the description" do
      it { should == json('{"message": "hello"}')  }
      it { should == json('{"message": "hello", "type": "greeting"}') }
      it { should == json('{"message": "hello", "type": "greeting", "length": "150"}') }
      it { should == json('{"message": "goodbye"}') }
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

