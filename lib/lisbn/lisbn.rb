class Lisbn < String
  # Returns a normalized ISBN form
  def isbn
    upcase.gsub(/[^0-9X]/, '')
  end

  # Returns true if the ISBN is valid, false otherwise.
  def valid?
    case isbn.length
      when 10
        valid_isbn_10?
      when 13
        valid_isbn_13?
      else
        false
    end
  end

  def isbn_with_dash
    if valid_isbn_13? && parts
      parts.join("-")
    elsif isbn.length > 3
      isbn[0..-2] + "-" + isbn[-1]
    else
      isbn
    end
  end

  # Returns a valid ISBN in ISBN-10 format.
  # Returns nil if the ISBN is invalid or incapable of conversion to ISBN-10.
  def isbn10
    return unless valid?
    return isbn if isbn.length == 10
    return unless isbn[0..2] == "978"

    isbn[3..-2] + isbn_10_checksum
  end

  # Returns a valid ISBN in ISBN-13 format.
  # Returns nil if the ISBN is invalid.
  def isbn13
    return unless valid?
    return isbn if isbn.length == 13

    '978' + isbn[0..-2] + isbn_13_checksum
  end

  # Returns an Array with the 'parts' of the ISBN-13 in left-to-right order.
  # The parts of an ISBN are as follows:
  #   - GS1 prefix
  #   - Group identifier
  #   - Prefix/publisher code
  #   - Item number
  #   - Check digit
  #
  # Returns nil if the ISBN is not valid.
  # Returns nil if the group and prefix cannot be identified.
  def parts
    return unless isbn13

    group = prefix = nil

    RANGES.each_pair do |g, prefixes|
      next unless isbn13.match("^#{g}")
      group = g

      pre_loc = group.length
      prefixes.each do |p|
        number = isbn13.slice(pre_loc, p[:length]).to_i
        next unless p[:range].include?(number)

        prefix = p.merge(:number => number)
        break
      end

      break
    end

    # In the unlikely event we can't categorize it...
    return unless group && prefix

    prefix = sprintf("%0#{prefix[:length]}d", prefix[:number])
    [group[0..2], group[3..-1], prefix, isbn13[(group.length + prefix.length)..-2], isbn13[-1..-1]]
  end

  def isbn_10_checksum
    base = isbn.length == 13 ? isbn[3..-2] : isbn[0..-2]

    sum = base[0].to_i * 10 +
          base[1].to_i *  9 +
          base[2].to_i *  8 +
          base[3].to_i *  7 +
          base[4].to_i *  6 +
          base[5].to_i *  5 +
          base[6].to_i *  4 +
          base[7].to_i *  3 +
          base[8].to_i *  2

    remainder = sum % 11

    case remainder
      when 0
        "0"
      when 1
        "X"
      else
        (11 - remainder).to_s
    end
  end

  def isbn_13_checksum
    base = (isbn.length == 13 ? '' : '978') + isbn[0..-2]

    sum = (
            base[1].to_i +
            base[3].to_i +
            base[5].to_i +
            base[7].to_i +
            base[9].to_i +
            base[11].to_i
          ) * 3 +
          base[0].to_i +
          base[2].to_i +
          base[4].to_i +
          base[6].to_i +
          base[8].to_i +
          base[10].to_i +
          base[12].to_i

    (10 - sum % 10).to_s[-1]
  end

  cache_method :isbn, :valid?, :isbn10, :isbn13, :parts, :isbn_10_checksum, :isbn_13_checksum

private

  def valid_isbn_10?
    return false unless isbn.match(/^[0-9]{9}[0-9X]$/)
    isbn[-1..-1] == isbn_10_checksum
  end

  def valid_isbn_13?
    return false unless isbn.match(/^[0-9]{13}$/)
    isbn[-1..-1] == isbn_13_checksum
  end

  RANGES = YAML::load_file(File.dirname(__FILE__) + "/../../data/ranges.yml")
end
