require 'spec_helper'
require 'contracted/application'

describe "a rack app mounted with contracted.mount" do
  before :all do @app = Contracted.mount(proc {|env| [200, {}, "body"]}, '9898') end

  after :all do @app.unmount end
  
  subject { @app }

  its(:host_and_port) { should == '0.0.0.0:9898' }

  it "should be able to perform GET operations" do
    @app.get('/', '', {}).should == 'body'
  end
end

describe "a rack app mounted with contracted.mount that returns a non 200 series status code" do
  it "should timeout after waiting 5 seconds" do
    Thin::Server.stub(:new).and_return(mock(:server, :running? => false))

    Timeout.timeout(6) do
      proc do
        Contracted.mount(proc {|env| [500, {}, "body"]}, '9898')
      end.should raise_error(Timeout::Error)
    end
  end  
end
