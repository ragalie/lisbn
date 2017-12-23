require 'spec_helper'

describe "Lisbn" do
  describe "#isbn" do
    it "converts the string to just digits and X" do
      isbn = Lisbn.new("9487-028asdfasdf878X7")
      isbn.isbn.should == "9487028878X7"
    end
  end

  describe "#valid?" do
    it "recognizes a valid ISBN10" do
      isbn = Lisbn.new("0123456789")
      isbn.valid?.should be true
    end

    it "recognizes a valid ISBN10 with X checksum" do
      isbn = Lisbn.new("160459411X")
      isbn.valid?.should be true
    end

    it "recognizes a valid ISBN10 with 0 checksum" do
      isbn = Lisbn.new("0679405070")
      isbn.valid?.should be true
    end

    it "recognizes an invalid ISBN10" do
      isbn = Lisbn.new("0123546789")
      isbn.valid?.should be false
    end

    it "recognizes a valid ISBN13" do
      isbn = Lisbn.new("9780000000002")
      isbn.valid?.should be true
    end

    it "recognizes a valid ISBN13 with 0 checksum" do
      isbn = Lisbn.new("9780062870780")
      isbn.valid?.should be true
    end

    it "recognizes an invalid ISBN13" do
      isbn = Lisbn.new("9780000000003")
      isbn.valid?.should be false
    end

    it "returns false for improperly-formatted ISBNs" do
      isbn = Lisbn.new("97800000X0002")
      isbn.valid?.should be false
    end

    it "regards anything not 10 or 13 digits as invalid" do
      isbn = Lisbn.new("")
      isbn.valid?.should be false
    end
  end

  describe "#isbn_with_dash" do
    subject { Lisbn.new(isbn) }

    context "with a 13-digit ISBN" do
      let(:isbn) { "9781402780592" }

      it "returns the isbn with dashes between the parts" do
        expect(subject.isbn_with_dash).to eq("978-1-4027-8059-2")
      end
    end

    context "with a 10-digit ISBN" do
      let(:isbn) { "1402780591" }

      it "returns the isbn with a dash before the checkdigit" do
        expect(subject.isbn_with_dash).to eq("140278059-1")
      end
    end

    context "with a very short ISBN" do
      let(:isbn) { "123" }

      it "returns the isbn" do
        expect(subject.isbn_with_dash).to eq(isbn)
      end
    end
  end

  describe "#isbn10" do
    subject { Lisbn.new("9780000000002") }

    it "returns nil if invalid" do
      subject.stub(:valid? => false)
      subject.isbn10.should be_nil
    end

    it "returns nil if the ISBN is 13-digits and isn't in the 978 GS1" do
      lisbn = Lisbn.new("9790000000003")
      lisbn.stub(:valid? => true)
      lisbn.isbn10.should be_nil
    end

    it "computes the ISBN10 checksum" do
      subject.isbn10.should == "0000000000"
    end

    it "returns the isbn if it's 10 digits" do
      lisbn = Lisbn.new("0000000000")
      lisbn.stub(:valid? => true)
      lisbn.should_not_receive(:isbn_10_checksum)
      lisbn.isbn10.should == "0000000000"
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
      lisbn.stub(:valid? => true)
      lisbn.should_not_receive(:isbn_13_checksum)
      lisbn.isbn13.should == "9780000000002"
    end

    it "provides a corrected checksum" do
      lisbn = Lisbn.new("9780000000001")
      lisbn.isbn13_checksum_corrected.should == "9780000000002"
    end

    it "can generate a publication range" do
      lisbn = Lisbn.new("9786017002015")
      lisbn.publication_range.to_s.should == "978-601-7002-00-8..978-601-7002-99-2"
    end
  end

  describe "#parts" do
    subject { Lisbn.new("9780000000002") }

    it "splits into the right groups" do
      subject.parts.should == ["978", "0", "00", "000000", "2"]
    end

    it "works with long groups" do
      lisbn = Lisbn.new("9786017002015")
      lisbn.parts.should == ["978", "601", "7002", "01", "5"]
    end

    it "returns nil if it can't find a valid group" do
      lisbn = Lisbn.new("9780100000002")
      lisbn.parts.should be_nil
    end
  end

  describe "#publication_range" do
    subject { Lisbn::PublicationRange.new("9786017002015") }

    it "returns a PublicationRange object" do
      subject.class.should == Lisbn::PublicationRange
    end

    it "returns the three parts of a PublicationRange" do
      subject.parts.should == ["978", "601", "7002"]
    end

    it "returns the number of publication in the range" do
      subject.number_of_publications.should == 100
    end

    it "returns the range of publication numbers" do
      subject.publication_numbers.should == (0..99)
    end

    it "returns a string representation of the range of ISBN13s" do
      subject.to_s.should == "978-601-7002-00-8..978-601-7002-99-2"
    end

    it "returns the range of isbns" do
      subject.isbn13s.should == [
        "9786017002008",
        "9786017002015",
        "9786017002022",
        "9786017002039",
        "9786017002046",
        "9786017002053",
        "9786017002060",
        "9786017002077",
        "9786017002084",
        "9786017002091",
        "9786017002107",
        "9786017002114",
        "9786017002121",
        "9786017002138",
        "9786017002145",
        "9786017002152",
        "9786017002169",
        "9786017002176",
        "9786017002183",
        "9786017002190",
        "9786017002206",
        "9786017002213",
        "9786017002220",
        "9786017002237",
        "9786017002244",
        "9786017002251",
        "9786017002268",
        "9786017002275",
        "9786017002282",
        "9786017002299",
        "9786017002305",
        "9786017002312",
        "9786017002329",
        "9786017002336",
        "9786017002343",
        "9786017002350",
        "9786017002367",
        "9786017002374",
        "9786017002381",
        "9786017002398",
        "9786017002404",
        "9786017002411",
        "9786017002428",
        "9786017002435",
        "9786017002442",
        "9786017002459",
        "9786017002466",
        "9786017002473",
        "9786017002480",
        "9786017002497",
        "9786017002503",
        "9786017002510",
        "9786017002527",
        "9786017002534",
        "9786017002541",
        "9786017002558",
        "9786017002565",
        "9786017002572",
        "9786017002589",
        "9786017002596",
        "9786017002602",
        "9786017002619",
        "9786017002626",
        "9786017002633",
        "9786017002640",
        "9786017002657",
        "9786017002664",
        "9786017002671",
        "9786017002688",
        "9786017002695",
        "9786017002701",
        "9786017002718",
        "9786017002725",
        "9786017002732",
        "9786017002749",
        "9786017002756",
        "9786017002763",
        "9786017002770",
        "9786017002787",
        "9786017002794",
        "9786017002800",
        "9786017002817",
        "9786017002824",
        "9786017002831",
        "9786017002848",
        "9786017002855",
        "9786017002862",
        "9786017002879",
        "9786017002886",
        "9786017002893",
        "9786017002909",
        "9786017002916",
        "9786017002923",
        "9786017002930",
        "9786017002947",
        "9786017002954",
        "9786017002961",
        "9786017002978",
        "9786017002985",
        "9786017002992"
      ]
    end
  end

  describe "ranges" do
    it "skips over invalid '0-length' ranges" do
      Lisbn::RANGES.values.flatten.map {|v| v[:length]}.should_not include(0)
    end
  end

  describe "retains normal string methods" do
    subject { Lisbn.new("9780000000002") }

    it "#splits" do
      subject.split("7").should == ["9",
        "80000000002"]
    end
  end
end
