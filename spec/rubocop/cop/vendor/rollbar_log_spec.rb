# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RollbarLog do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `Rollbar.log` with string' do
    expect_offense(<<-RUBY.strip_indent)
      Rollbar.log('error', 'Unhandled exception')
                  ^^^^^^^ Use `Rollbar.error` instead of `Rollbar.log`.
    RUBY
  end

  it 'registers an offense when using `Rollbar.log` with symbol' do
    expect_offense(<<-RUBY.strip_indent)
      Rollbar.log(:info, 'Unhandled exception')
                  ^^^^^ Use `Rollbar.info` instead of `Rollbar.log`.
    RUBY
  end

  it 'does not register an offense when using `Rollbar.error`' do
    expect_no_offenses(<<-RUBY.strip_indent)
      Rollbar.error(exception, "Unhandled exception.")
    RUBY
  end
end
