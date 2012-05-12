require 'spec_helper'

class String
  extend Lisbn::CacheMethod

  def with_excitement!
    self + "!"
  end

  cache_method :with_excitement!
end

describe "cache_method" do
  subject { String.new("awesomeness") }

  it "evaluates the method the first time but not subsequent times" do
    subject.should_receive(:+).with("!").once.and_return("you got stubbed!")
    subject.with_excitement!
    subject.with_excitement!.should == "you got stubbed!"
  end

  it "reevaluates the method if the object's hash changes" do
    subject.with_excitement!.should == "awesomeness!"
    subject.replace("more awesomeness")
    subject.with_excitement!.should == "more awesomeness!"
  end
end
