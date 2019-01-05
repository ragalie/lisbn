require 'spec_helper'

class String
  extend Lisbn::CacheMethod

  def with_excitement!(how_much = 1)
    self + "!" * how_much
  end

  cache_method :with_excitement!
end

describe "cache_method" do
  subject { String.new("awesomeness") }

  it "evaluates the method the first time but not subsequent times" do
    expect(subject).to receive(:+).with("!").once.and_call_original
    subject.with_excitement!
    subject.with_excitement!
  end

  it "reevaluates the method if the arguments change" do
    expect(subject).to receive(:+).with("!")
    expect(subject).to receive(:+).with("!!")
    subject.with_excitement!
    subject.with_excitement!(2)
  end

  it "reevaluates the method if the block changes" do
    expect(subject).to receive(:+).twice.and_call_original
    subject.with_excitement! { "cats" }
    subject.with_excitement! { "dogs" }
  end

  it "reevaluates the method if the object's hash changes" do
    expect(subject.with_excitement!).to eq("awesomeness!")
    subject.replace("more awesomeness")
    expect(subject.with_excitement!).to eq("more awesomeness!")
  end
end
