# Magellan::Cli

[![Gem Version](https://badge.fury.io/rb/magellan-cli.png)](https://rubygems.org/gems/magellan-cli) [![Build Status](https://secure.travis-ci.org/tengine/magellan-cli.png)](https://travis-ci.org/tengine/magellan-cli)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'magellan-cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magellan-cli


## Usage

- [Getting Started](http://devcenter.magellanic-clouds.com/getting-started/)
- [Reference en](reference/en/index.md)
- [Reference ja](reference/ja/index.md)


## generate reference pages

update `references` dir in this repository.

```
bundle exec rake reference
```

update `references` dir in devcenter repository


```
bundle exec rake reference:devcenter
```

then check the references updated.

After check the pages, you can commit the .md files to magellan-devcenter.github.io repogitory.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/magellan-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
