# Vendor

## Vendor/ActiveRecordConnectionExecute

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop checks for `ActiveRecord::Connection#execute` usage and suggests
using non-manually memory managed objects instead.

The main reason for this is this is a common way to leak memory in a Ruby on Rails application.
see {
https://github.com/rails/rails/blob/a19b13b61f7af612569943ec7d536185cbec875c/activerecord/lib/active_record/connection_adapters/abstract/database_statements.rb#L127
ActiveRecord documentation
}.

### Examples

```ruby
# bad
ActiveRecord::Base.connection.execute('SELECT * FROM users')
ApplicationRecord.connection.execute('SELECT * FROM users')
User.connection.execute('SELECT * FROM users')

# good
ActiveRecord::Base.connection.select_all('SELECT * FROM users')
ApplicationRecord.connection.select_all('SELECT * FROM users')
User.connection.select_all('SELECT * FROM users')
```

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

## Vendor/StrictDryStruct

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop flags uses of DryStruct without strict mode

By default DryStruct will not throw an error if passed an attribute that wasn't defined.
We want to enfore strict mode which will throw an error in that case.

## Vendor/WsSdkPathArraySlash

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop checks for `Ws::Service#get,patch,post,put,delete,...` usage
where the array format is used, but it contains (probably not) intended slashes.
These slashes will be converted to %2f instead of a path component.

### Examples

```ruby
# bad
Ws::AccountService.post(["/test/foo"]) # forward flash will be converted to %2f

# good
Ws::AccountService.post(["test", "foo"])
```

## Vendor/WsSdkPathInjection

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | - | -

This cop checks for `Ws::Service#get,patch,post,put,delete,...` usage and suggests to use component based paths
instead of using interpolated values that could be user input.

This is to avoid path injection, a potential security vulnerability!

### Examples

```ruby
# bad
# could post to /api/accounts with same credentials (e.g. by passing "?" as account_id)
Ws::AccountService.post("/api/accounts/#{account_id}/details")

# good
Ws::AccountService.post(["api","accounts", account_id, "details"])

# okay, but prefer above
Ws::AccountService.post("/api/accounts/#{URI.encode_www_component(account_id)}")
```
