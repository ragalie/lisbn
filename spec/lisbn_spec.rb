require 'spec_helper'

describe "Lisbn" do
  describe "#isbn" do
    it "converts the string to just digits and X" do
      isbn = Lisbn.new("9487-028asdfasdf878X7")
      expect(isbn.isbn).to eq("9487028878X7")
    end
  end

  describe "#valid?" do
    it "recognizes a valid ISBN10" do
      isbn = Lisbn.new("0123456789")
      expect(isbn.valid?).to be true
    end

    it "recognizes a valid ISBN10 with X checksum" do
      isbn = Lisbn.new("160459411X")
      expect(isbn.valid?).to be true
    end

    it "recognizes a valid ISBN10 with 0 checksum" do
      isbn = Lisbn.new("0679405070")
      expect(isbn.valid?).to be true
    end

    it "recognizes an invalid ISBN10" do
      isbn = Lisbn.new("0123546789")
      expect(isbn.valid?).to be false
    end

    it "recognizes a valid ISBN13" do
      isbn = Lisbn.new("9780000000002")
      expect(isbn.valid?).to be true
    end

    it "recognizes a valid ISBN13 with 0 checksum" do
      isbn = Lisbn.new("9780062870780")
      expect(isbn.valid?).to be true
    end

    it "recognizes an invalid ISBN13" do
      isbn = Lisbn.new("9780000000003")
      expect(isbn.valid?).to be false
    end

    it "returns false for improperly-formatted ISBNs" do
      isbn = Lisbn.new("97800000X0002")
      expect(isbn.valid?).to be false
    end

    it "regards anything not 10 or 13 digits as invalid" do
      isbn = Lisbn.new("")
      expect(isbn.valid?).to be false
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
      allow(subject).to receive(:valid?) { false }
      expect(subject.isbn10).to be_nil
    end

    it "returns nil if the ISBN is 13-digits and isn't in the 978 GS1" do
      lisbn = Lisbn.new("9790000000003")
      allow(lisbn).to receive(:valid?) { true }
      expect(lisbn.isbn10).to be_nil
    end

    it "computes the ISBN10 checksum" do
      expect(subject.isbn10).to eq("0000000000")
    end

    it "returns the isbn if it's 10 digits" do
      lisbn = Lisbn.new("0000000000")
      allow(lisbn).to receive(:valid?) { true }
      expect(lisbn).not_to receive(:isbn_10_checksum)
      expect(lisbn.isbn10).to eq("0000000000")
    end
  end

  describe "#isbn13" do
    subject { Lisbn.new("0000000000") }

    it "returns nil if invalid" do
      allow(subject).to receive(:valid?) { false }
      expect(subject.isbn13).to be_nil
    end

    it "computes the ISBN13 checksum" do
      expect(subject.isbn13).to eq("9780000000002")
    end

    it "returns the isbn if it's 13 digits" do
      lisbn = Lisbn.new("9780000000002")
      allow(lisbn).to receive(:valid?) { true }
      expect(lisbn).not_to receive(:isbn_13_checksum)
      expect(lisbn.isbn13).to eq("9780000000002")
    end
  end

  describe "#parts" do
    subject { Lisbn.new("9780000000002") }

    it "splits into the right groups" do
      expect(subject.parts).to eq(["978", "0", "00", "000000", "2"])
    end

    it "works with long groups" do
      lisbn = Lisbn.new("9786017002015")
      expect(lisbn.parts).to eq(["978", "601", "7002", "01", "5"])
    end

    it "should raise ArgumentError for anything other than 4 or 5" do
      expect { subject.parts(3) }.to raise_error(ArgumentError)
    end

    it "splits into the right groups with number argument" do
      expect(subject.parts(5)).to eq(["978", "0", "00", "000000", "2"])
    end

    it "returns nil if it can't find a valid group" do
      lisbn = Lisbn.new("9780100000002")
      expect(lisbn.parts).to be_nil
    end

    context "4 parts variant" do
      it "splits isbn10 for parts with argument" do
        lisbn = Lisbn.new("832100928X")
        expect(lisbn.parts(4)).to eq(["83", "210", "0928", "X"])
      end

      it "works correctly for publisher identifier (CRC Press)" do
        lisbn = Lisbn.new("0849304768")
        expect(lisbn.parts(4)).to eq(["0", "8493", "0476", "8"])
      end

      it "works correctly with long publisher identifier (Tarquin Publications)" do
        lisbn = Lisbn.new("0906212731")
        expect(lisbn.parts(4)).to eq(["0", "906212", "73", "1"])
      end

      it "splits isbn10 for parts for initial isbn13" do
        lisbn = Lisbn.new("9786017002015")
        expect(lisbn.parts(4)).to eq(["601", "7002", "01", "5"])
      end

      it 'returns nil if ISBN-10 equivalent doesnt exists' do
        lisbn = Lisbn.new("979-11-86178-14-0")
        expect(lisbn.parts(4)).to be_nil
      end

      it "returns nil if it can't find a valid group" do
        lisbn = Lisbn.new("9780100000002")
        expect(lisbn.parts(4)).to be_nil
      end
    end
  end

  describe "ranges" do
    it "skips over invalid '0-length' ranges" do
      range_lengths = Lisbn::RANGES.values.flatten.map {|v| v[:length]}
      expect(range_lengths).not_to include(0)
    end
  end

  describe "retains normal string methods" do
    subject { Lisbn.new("9780000000002") }

    it "#splits" do
      expect(subject.split("7")).to eq(["9", "80000000002"])
    end
  end
end
