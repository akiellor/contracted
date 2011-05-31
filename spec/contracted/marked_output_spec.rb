require 'spec_helper'
require 'contracted/marked_output'

describe Contracted::MarkedOutput do
  context "single line output" do
    let(:output) { "Some output\n" }
    
    subject { Contracted::MarkedOutput.new(output).mark(:column => 2, :line => 1) }

    it { should == %q{Some output
 ^}
    }
  end

  context "multiline line output" do
    let(:output) { "Some output\nSome more output\nAnd some more\n" }

    subject { Contracted::MarkedOutput.new(output).mark(:column => 4, :line => 2) }

    it { should == %q{Some output
Some more output
   ^
And some more}
    }
  end

  context "many many lines of output" do
    let(:output) { (1..30).map {|i| "Some output line #{i}"}.join("\n") }

    subject { Contracted::MarkedOutput.new(output).mark(:column => 8, :line => 17) }

    it { should == %q{Some output line 15
Some output line 16
Some output line 17
       ^
Some output line 18
Some output line 19}
    }
  end

end
