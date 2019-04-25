# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RollbarLogger do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `Rollbar.debug`' do
    expect_offense(<<-RUBY.strip_indent)
      Rollbar.debug('Stale message')
      ^^^^^^^ Use `Rails.logger` for `debug`, `info` or `warning` calls.
    RUBY
  end

  it 'registers an offense when using `Rollbar.info`' do
    expect_offense(<<-RUBY.strip_indent)
      Rollbar.info 'Stale message'
      ^^^^^^^ Use `Rails.logger` for `debug`, `info` or `warning` calls.
    RUBY
  end

  it 'registers an offense when using `Rollbar.warning`' do
    expect_offense(<<-RUBY.strip_indent)
      Rollbar.warning 'Low resources'
      ^^^^^^^ Use `Rails.logger` for `debug`, `info` or `warning` calls.
    RUBY
  end

  it 'does not register an offense when using multiple parameters' do
    expect_no_offenses(<<-RUBY.strip_indent)
      Rollbar.warning(exception, 'Inconsistency detected.')
    RUBY
  end

  it 'does not register an offense when using `Rails.logger.debug`' do
    expect_no_offenses(<<-RUBY.strip_indent)
      Rails.logger.debug('Stale message')
    RUBY
  end

  it 'does not register an offense when using `Rails.logger.info`' do
    expect_no_offenses(<<-RUBY.strip_indent)
      Rails.logger.info('Stale message')
    RUBY
  end

  it 'autocorrect `Rollbar.debug(<string>)` to `Rails.logger.debug`' do
    expect(autocorrect_source('Rollbar.debug("Stale message")')).to eq('Rails.logger.debug("Stale message")')
  end

  it 'autocorrect `Rollbar.info <string>` to `Rails.logger.info`' do
    expect(autocorrect_source('Rollbar.info "Stale message"')).to eq('Rails.logger.info "Stale message"')
  end

  it 'autocorrect `Rollbar.debug(<hash>)` to `Rails.logger.debug`' do
    expect(autocorrect_source('Rollbar.debug({foo: "bar"})')).to eq('Rails.logger.debug({foo: "bar"})')
  end

  it 'autocorrect `Rollbar.debug(<bracketless hash>)` to `Rails.logger.debug`' do
    expect(autocorrect_source('Rollbar.debug(foo: "bar")')).to eq('Rails.logger.debug(foo: "bar")')
  end

  it 'does not autocorrect `Rollbar.debug(<string>, <hash>)` to `Rails.logger.debug`' do
    correct_source = 'Rollbar.debug("Stale message", {foo: "bar"})'
    expect(autocorrect_source(correct_source)).to eq(correct_source)
  end
end
