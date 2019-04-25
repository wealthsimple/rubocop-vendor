# Vendor

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
Enabled | Yes | Yes  | 0.2.0 | -

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
Enabled | Yes | Yes  | 0.1.0 | -

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
