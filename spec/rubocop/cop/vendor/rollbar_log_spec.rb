# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RollbarLog, :config do
  it 'registers an offense when using `Rollbar.log` with string' do
    expect_offense(<<~RUBY)
      Rollbar.log('error', 'Unhandled exception')
              ^^^^^^^^^^^^^ Use `Rollbar.error` instead of `Rollbar.log`.
    RUBY
  end

  it 'registers an offense when using `Rollbar.log` with symbol' do
    expect_offense(<<~RUBY)
      Rollbar.log(:info, 'Unhandled exception')
              ^^^^^^^^^^^ Use `Rollbar.info` instead of `Rollbar.log`.
    RUBY
  end

  it 'does not register an offense when using `Rollbar.error`' do
    expect_no_offenses(<<~RUBY)
      Rollbar.error(exception, "Unhandled exception.")
    RUBY
  end

  it 'autocorrect `Rollbar.log(:info` to `Rollbar.info`' do
    expect(autocorrect_source('Rollbar.log(:info, "Stale message")')).to eq('Rollbar.info("Stale message")')
  end

  it 'autocorrect `Rollbar.log("error"` to `Rollbar.error`' do
    expect(autocorrect_source('Rollbar.log "error", "Stale message"')).to eq('Rollbar.error "Stale message"')
  end
end
