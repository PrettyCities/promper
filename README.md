# Promper

Promper is a dog who loves to fetch similar words. Simply give him an English word or phrase and he will run off to find other words or phrases that sound similar!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'promper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install promper

## Usage

1.) Require Promper with `require 'promper'`.
2.) Initialize a new instance of Promper with `promper = Promper.new`.
3a.) If you are running Promper from IRB, set him free with `promper.go_boy`. Promper speak to you and continually query you until you enter a blank line.
3b.) Alternatively, if you simply want to use Promper for his functionality, use `promper.search("target word or phrase")`. Promper will return an array of similar sounding words.

Note: At this point in his life, Promper is very ambitious. He sometimes returns a lot of matches (especially for long phrases!). So, to make managing Promper's responses easier, you should search for short words/phrases. For example, if you want to find matches to the phrase "Dogs are the best animals", you may be tempted to use `promper.search("Dogs are the best animals")`. However, this will return an array containing 80,000+ elements. You are better off breaking this query into smaller chunks with something like `promper.search("Dogs are the")` and `promper.search("best animals")`. Then, comb through the results and find your favorite combinations.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PrettyCities/promper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

