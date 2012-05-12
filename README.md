# Lisbn

Lisbn (pronounced "Lisbon") is a wrapper around String that adds methods for manipulating
[ISBNs](http://en.wikipedia.org/wiki/International_Standard_Book_Number).

## Installation

Add this line to your application's Gemfile:

    gem 'lisbn'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lisbn

## Usage

Instantiate a new Lisbn object:

    > isbn = Lisbn.new("9780000000002")

You can check its validity:

    > isbn.valid?
     => true

You can convert it to ISBN-10 or ISBN-13:

    > isbn.isbn10
     => "0000000000"

    > isbn.isbn13
     => "9780000000002"

And you can break it up into its GS1 prefix, group identifier, prefix/publisher code,
item number and check digit:

    > isbn.parts
     => ["978", "0", "00", "000000", "2"]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
