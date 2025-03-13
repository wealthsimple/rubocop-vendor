# rubocop-vendor

[![Gem Version](https://badge.fury.io/rb/rubocop-vendor.svg)](https://badge.fury.io/rb/rubocop-vendor)
[![GitHub Actions Badge](https://github.com/wealthsimple/rubocop-vendor/actions/workflows/main.yml/badge.svg)](https://github.com/wealthsimple/rubocop-vendor/actions)

Vendor integration analysis for your projects, as an extension to [RuboCop](https://github.com/rubocop-hq/rubocop).

## Installation

Just install the `rubocop-vendor` gem

```sh
gem install rubocop-vendor
```

or if you use bundler put this in your `Gemfile`

```ruby
gem 'rubocop-vendor'
```

## Usage

You need to tell RuboCop to load the Vendor extension. There are three
ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```yaml
plugins:
 - rubocop-vendor
```

Now you can run `rubocop` and it will automatically load the RuboCop Vendor
cops together with the standard cops.

### Command line

```sh
rubocop --require rubocop-vendor
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-vendor'
end
```

## The Cops

All cops are located under
[`lib/rubocop/cop/vendor`](lib/rubocop/cop/vendor), and contain
examples/documentation.

In your `.rubocop.yml`, you may treat the Vendor cops just like any other
cop. For example:

```yaml
Vendor/RollbarLogger:
  Exclude:
    - lib/example.rb
```

## Contributing

Checkout the [contribution guidelines](CONTRIBUTING.md).

## License

`rubocop-vendor` is MIT licensed. [See the accompanying file](LICENSE) for
the full text.
