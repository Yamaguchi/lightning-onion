# Lightning::Onion

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/lightning/onion`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lightning-onion'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lightning-onion

## Usage

### Build Onion Packet 

    $ ./bin/console
    irb(main):001:0> irb(main):002:0> session_key = '4141414141414141414141414141414141414141414141414141414141414141'
    irb(main):003:0> public_keys = [
    irb(main):004:1*       '02eec7245d6b7d2ccb30380bfbe2a3648cd7a942653f5aa340edcea1f283686619',
    irb(main):005:1*       '0324653eac434488002cc06bbfb7f10fe18991e35f9fe4302dbea6d2353dc0ab1c',
    irb(main):006:1*       '027f31ebc5462c1fdce1b737ecff52d37d75dea43ce11c74d25aa297165faa2007',
    irb(main):007:1*       '032c0b7cf95324a07d05398b240174dc0c2be444d96b159aa6c7f7b1e668680991',
    irb(main):008:1*       '02edabbd16b41c8371b92ef2f04c1185b4f03b6dcd52ba9b78d9d7c89c8f221145'
    irb(main):009:1> ]
    irb(main):010:0> payloads = [
    irb(main):011:1*       '000000000000000000000000000000000000000000000000000000000000000000',
    irb(main):012:1*       '000101010101010101000000010000000100000000000000000000000000000000',
    irb(main):013:1*       '000202020202020202000000020000000200000000000000000000000000000000',
    irb(main):014:1*       '000303030303030303000000030000000300000000000000000000000000000000',
    irb(main):015:1*       '000404040404040404000000040000000400000000000000000000000000000000'
    irb(main):016:1> ]
    irb(main):017:0> associated_data = '4242424242424242424242424242424242424242424242424242424242424242'
    irb(main):018:0> onion, secrets = Lightning::Onion::Sphinx.make_packet(session_key, public_keys, payloads, associated_data)

### Parse Onion Packet 

    irb(main):019:0> private_keys = [
    irb(main):020:1*       '4141414141414141414141414141414141414141414141414141414141414141',
    irb(main):021:1*       '4242424242424242424242424242424242424242424242424242424242424242',
    irb(main):022:1*       '4343434343434343434343434343434343434343434343434343434343434343',
    irb(main):023:1*       '4444444444444444444444444444444444444444444444444444444444444444',
    irb(main):024:1*       '4545454545454545454545454545454545454545454545454545454545454545'
    irb(main):025:1> ]
    irb(main):028:0> payload0, next_packet0, = Lightning::Onion::Sphinx.parse(private_keys[0], onion.to_payload)
    irb(main):029:0> payload1, next_packet1, = Lightning::Onion::Sphinx.parse(private_keys[1], next_packet0.to_payload)
    irb(main):030:0> payload2, next_packet2, = Lightning::Onion::Sphinx.parse(private_keys[2], next_packet1.to_payload)
    irb(main):031:0> payload3, next_packet3, = Lightning::Onion::Sphinx.parse(private_keys[3], next_packet2.to_payload)
    irb(main):032:0> payload4, next_packet4, = Lightning::Onion::Sphinx.parse(private_keys[4], next_packet3.to_payload)
    irb(main):035:0> payload0.bth
    => "000000000000000000000000000000000000000000000000000000000000000000"
    irb(main):036:0> payload1.bth
    => "000101010101010101000000010000000100000000000000000000000000000000"
    irb(main):037:0> payload2.bth
    => "000202020202020202000000020000000200000000000000000000000000000000"
    irb(main):038:0> payload3.bth
    => "000303030303030303000000030000000300000000000000000000000000000000"
    irb(main):039:0> payload4.bth
    => "000404040404040404000000040000000400000000000000000000000000000000"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Yamaguchi/lightning-onion. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
