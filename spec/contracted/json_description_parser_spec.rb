require 'polyglot'
require 'treetop'
require 'contracted/json_description'

describe JsonDescriptionParser do
  let(:parser) { JsonDescriptionParser.new } 
  let(:description) { parser.parse(description_string) }

  subject { description.matcher }

  context "a standard json representation" do
    let(:description_string) { '{"message": "hello"}' }
    
    describe "the description" do
      it { should be_match '{"message": "hello"}' }
      it { should_not be_match '{"message": "goodbye"}' }
    end
  end

  context "with a key wildcard" do
    let(:description_string) { '{"message": "hello", ...}' }

    describe "the description" do
      it { pending(subject.inspect); should be_match '{"message": "hello"}'  }
      it { pending(subject.inspect); should be_match '{"message": "hello", "type": "greeting"}' }
      it { pending(subject.inspect); should_not be_match '{"message": "goodbye"}' }
      it { pending(subject.inspect); should_not be_match '{"type": "greeting"}' }
    end
  end

  context "with a wildcard value" do
    let(:description_string) { '{"message": ..., "type": "greeting" }' }

    describe "the description" do
      it { pending(subject.inspect); should be_match '{"message": "hello", "type": "greeting" }' }
      it { pending(subject.inspect); should be_match '{"message": "goodbye", "type": "greeting" }' }
      it { pending(subject.inspect); should_not be_match '{"msg": "hello", "type": "greeting" }' }
      it { pending(subject.inspect); should_not be_match '{"message": "hello"}' }
      it { pending(subject.inspect); should_not be_match '{"type": "greeting"}' }
    end
  end
end

