require 'spec_helper'

describe "Lisbn" do
  describe "#initialize" do
    it "converts the passed ISBN to just digits and X" do
      isbn = Lisbn.new("9487-028asdfasdf878X7")
      isbn.isbn.should == "9487028878X7"
    end
  end

  describe "#valid?" do
    it "recognizes a valid ISBN10" do
      isbn = Lisbn.new("0123456789")
      isbn.valid?.should be_true
    end

    it "recognizes an invalid ISBN10" do
      isbn = Lisbn.new("0123546789")
      isbn.valid?.should be_false
    end

    it "recognizes a valid ISBN13" do
      isbn = Lisbn.new("9780000000002")
      isbn.valid?.should be_true
    end

    it "recognizes an invalid ISBN13" do
      isbn = Lisbn.new("9780000000003")
      isbn.valid?.should be_false
    end

    it "returns false for improperly-formatted ISBNs" do
      isbn = Lisbn.new("97800000X0002")
      isbn.valid?.should be_false
    end

    it "regards anything not 10 or 13 digits as invalid" do
      isbn = Lisbn.new("")
      isbn.valid?.should be_false
    end
  end

  describe "#isbn13" do
    subject { Lisbn.new("0000000000") }

    it "returns nil if invalid" do
      subject.stub(:valid? => false)
      subject.isbn13.should be_nil
    end

    it "computes the ISBN13 checksum" do
      subject.isbn13.should == "9780000000002"
    end

    it "returns the isbn if it's 13 digits" do
      lisbn = Lisbn.new("9780000000002")
      lisbn.should_receive(:isbn_13_checksum).once.and_return("2")
      lisbn.isbn13.should == "9780000000002"
    end
  end

  describe "#split" do
    subject { Lisbn.new("9780000000002") }

    it "splits into the right groups" do
      subject.split.should == ["978", "0", "00", "000000", "2"]
    end

    it "returns nil if it can't find a valid group" do
      lisbn = Lisbn.new("9780100000002")
      lisbn.split.should be_nil
    end
  end
end
