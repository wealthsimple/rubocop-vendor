# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RollbarInsideRescue, :config, :config do
  it 'registers an offense when using `Rollbar.error` without rescue' do
    expect_offense(<<~RUBY)
      Rollbar.error('Unable to perform division')
      ^^^^^^^ Only call Rollbar when handling errors inside a `rescue` block.
    RUBY
  end

  it 'registers an offense when using `Rollbar.critical` without rescue' do
    expect_offense(<<~RUBY)
      class Foo
        def bar
          Rollbar.critical('Unable to perform division')
          ^^^^^^^ Only call Rollbar when handling errors inside a `rescue` block.
        end
      end
    RUBY
  end

  it 'does not register an offense when using `Rollbar.error` with begin/rescue' do
    expect_no_offenses(<<~RUBY)
      begin
        1 / 0
      rescue ZeroDivisionError => ex
        if 0 == 1
          Rollbar.error(ex)
        end
      end
    RUBY
  end

  it 'does not register an offense when using `Rollbar.critical` with def/rescue' do
    expect_no_offenses(<<~RUBY)
      def bad_math
        1 / 0
      rescue StandardError => e
        Rollbar.critical(e)
      end
    RUBY
  end

  it 'does not register an offense when using `Rollbar.error` with inline rescue' do
    expect_no_offenses(<<~RUBY)
      1 / 0 rescue Rollbar.debug('Unable to perform division')
    RUBY
  end

  it 'does not register offense when using `Rollbar.error` with ActiveSupport::Rescuable#rescue_from' do
    expect_no_offenses(<<~RUBY)
      rescue_from InvalidRecord do |e|
        Rollbar.error(e)
      end
    RUBY
  end
end
