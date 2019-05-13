# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RollbarWithException do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `Rollbar.error` without exception' do
    expect_offense(<<-RUBY.strip_indent)
      begin
        1 / 0
      rescue ZeroDivisionError
        Rollbar.error('Unable to perform division')
                      ^ Send exception as first parameter when calling `error` or `critical`.
      end

    RUBY
  end

  it 'registers an offense when using `Rollbar.critical` without exception' do
    expect_offense(<<-RUBY.strip_indent)
      Rollbar.critical('Service unavailable.')
                       ^ Send exception as first parameter when calling `error` or `critical`.
    RUBY
  end

  it 'register an offense when using `Rollbar.error` with inline rescue' do
    expect_offense(<<-RUBY.strip_indent)
      1 / 0 rescue Rollbar.error('Unable to perform division')
                                 ^ Send exception as first parameter when calling `error` or `critical`.
    RUBY
  end

  it 'does not register an offense when using `Rollbar.error` with exception' do
    expect_no_offenses(<<-RUBY.strip_indent)
      begin
        1 / 0
      rescue ZeroDivisionError => ex
        Rollbar.error(ex, 'Unable to perform division')
      end
    RUBY
  end
end
