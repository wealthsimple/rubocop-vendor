# Vendor

## Vendor/RecursiveOpenStructGem

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop flags uses of the recursive-open-struct gem.

RecursiveOpenStruct inherits from OpenStruct, which is now officially discouraged to be used
for performance, version compatibility, and security issues.

https://ruby-doc.org/stdlib-3.0.1/libdoc/ostruct/rdoc/OpenStruct.html#class-OpenStruct-label-Caveats

## Vendor/RecursiveOpenStructUse

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop flags uses of RecursiveOpenStruct. RecursiveOpenStruct is a library used in the
Wealthsimple ecosystem that is being phased out due to security issues.

RecursiveOpenStruct inherits from OpenStruct, which is now officially discouraged to be used
for performance, version compatibility, and security issues.

### Examples

```ruby
# bad
point = RecursiveOpenStruct.new(x: 0, y: 1)

# good
Point = Struct.new(:x, :y)
point = Point.new(0, 1)

# also good
point = { x: 0, y: 1 }

# bad
test_double = RecursiveOpenStruct.new(a: 'b')

# good (assumes test using rspec-mocks)
test_double = double
allow(test_double).to receive(:a).and_return('b')
```

## Vendor/RollbarInsideRescue

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop checks for Rollbar calls outside `rescue` blocks.

The main reason for this suggestion is that Rollbar should not be used
as a logger given it has a quota that is often multiple times smaller
than the log quota. By reporting errors outside rescue blocks
the developer is most likely in control of the exceptional flow and
won't need a stack trace.

### Examples

```ruby
# bad
Rollbar.error("Unable to sync account")

# good
begin
  1 / 0
rescue StandardError => exception
  Rollbar.error(exception, "Unable to sync account")
end

# good
class ApplicationController < ActionController::Base
  rescue_from InvalidRecord do |e|
    Rollbar.error(e)
  end
end
```

## Vendor/RollbarInterpolation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | 0.1.0 | -

This cop checks for interpolated message when calling `Rollbar.error`
and suggests sending extra fields as hash parameter instead.

The main reason for this suggestion is that Rollbar will have a harder
time grouping messages that are dynamic.

### Examples

```ruby
# bad
Rollbar.error(e, "Unable to sync account #{account.id}")

# good
Rollbar.error(e, "Unable to sync account", account_id: account.id)
```

## Vendor/RollbarLog

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | 0.2.0 | -

This cop checks for `Rollbar.log` usage and suggests specialized
method calls instead.

The main reason for this suggestion is consistency.

### Examples

```ruby
# bad
Rollbar.log('info', 'Stale message')

# good
Rollbar.info('Stale message')
```

## Vendor/RollbarLogger

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | 0.1.0 | -

This cop checks for non-error usage of Rollbar and suggests using
`Rails.logger` instead.

The main reason for this suggestion is that Rollbar has a quota that is
often multiple times smaller than the log quota and it may become
expensive, also an error tracker should *not* be used as a logger.

### Examples

```ruby
# bad
Rollbar.info("Stale message")

# good
Rails.logger.info("Stale message")
```

## Vendor/RollbarWithException

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | 0.1.0 | -

This cop checks for the exception *not* being passed when calling
`Rollbar.error` or `Rollbar.critical` and suggests sending it as
the first parameter.

The main reason for this suggestion is that Rollbar will display the
stack trace along with the error message which will be useful
when debugging the issue. If the error is not needed consider using the
logger instead.

### Examples

```ruby
# bad
Rollbar.error("Unable to sync account")

# good
Rollbar.error(exception, "Unable to sync account")
```

## Vendor/SidekiqThrottledGem

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop flags uses of the sidekiq-throttled gem.

sidekiq-throttled overrides sidekiq-pro and sidekiq-enterprise features,
resulting in at-most once delivery of sidekiq jobs, instead of at-least once delivery
of sidekiq jobs. This means there is a relatively good chance you will LOSE JOBS that were enqueued
if the sidekiq-process runs out of memory or does not shutdown gracefully.

https://wealthsimple.slack.com/archives/C19UB3HNZ/p1683721247371709 for more details

## Vendor/StrictDryStruct

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop flags uses of DryStruct without strict mode

By default DryStruct will not throw an error if passed an attribute that wasn't defined.
We want to enfore strict mode which will throw an error in that case.
