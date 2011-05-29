require 'polyglot'
require 'treetop'
require 'contracted/json_description'

describe JsonDescriptionParser do
  let(:description) { JsonDescriptionParser.new.parse(description_string) }

  context "a standard json representation" do
    let(:description_string) { "{'message': 'hello'}" }
    
    describe "the description" do
      subject { description }

      it { pending; should be_match "{'message': 'hello'}" }
    end
  end

  context "with a key wildcard" do
    let(:description_string) { "{'message': 'hello', ...}" }

    describe "the description" do
      subject { description }

      it { pending; should be_match "{'message': 'hello'}"  }
      it { pending; should be_match "{'message': 'hello', 'type': 'greeting'}" }
      it { pending; should_not be_match "{'message': 'goodbye'}" }
      it { pending; should_not be_match "{'type': 'greeting'}" }
    end
  end

  context "with a wildcard value" do
    let(:description_string) { "{'message': ..., 'type': 'greeting' }" }

    describe "the description" do
      subject { description }

      it { pending; should be_match "{'message': 'hello', 'type': 'greeting' }" }
      it { pending; should be_match "{'message': 'goodbye', 'type': 'greeting' }" }
      it { pending; should_not be_match "{'msg': 'hello', 'type': 'greeting' }" }
      it { pending; should_not be_match "{'message': 'hello'}" }
      it { pending; should_not be_match "{'type': 'greeting'}" }
    end
  end
end

