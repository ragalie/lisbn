class Lisbn < String
  class PublicationRange
    def initialize(seed_isbn13)
      @seed_isbn13 = Lisbn.new(seed_isbn13)
    end

    def parts
      seed_isbn13.parts[0..2]
    end

    def prefix
      parts.join
    end

    def to_s
      "#{Lisbn.new(from).isbn_with_dash}..#{Lisbn.new(to).isbn_with_dash}"
    end

    def number_of_publications
      10 ** (13 - prefix.size - 1)
    end

    def publication_numbers
      (0..(number_of_publications-1))
    end

    def isbn13s
      (from_prefix..to_prefix).to_a.map{|i| Lisbn.new((i*10).to_s).isbn13_checksum_corrected}
    end

    private
    attr_reader :seed_isbn13

    def multiplier
      (10 ** (12 - prefix.size))
    end

    def from_prefix
      prefix.to_i * multiplier
    end

    def to_prefix
      (prefix.to_i+1) * multiplier - 1
    end

    def from
      Lisbn.new((from_prefix*10).to_s).isbn13_checksum_corrected
    end

    def to
      Lisbn.new((to_prefix*10).to_s).isbn13_checksum_corrected
    end
  end
end
