# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RollbarInsideRescue do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `Rollbar.error` without rescue' do
    expect_offense(<<-RUBY.strip_indent)
      Rollbar.error('Unable to perform division')
      ^^^^^^^ Only call Rollbar when handling errors inside a `rescue` block.
    RUBY
  end

  it 'registers an offense when using `Rollbar.critical` without rescue' do
    expect_offense(<<-RUBY.strip_indent)
      class Foo
        def bar
          Rollbar.critical('Unable to perform division')
          ^^^^^^^ Only call Rollbar when handling errors inside a `rescue` block.
        end
      end
    RUBY
  end

  it 'does not register an offense when using `Rollbar.error` with begin/rescue' do
    expect_no_offenses(<<-RUBY.strip_indent)
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
    expect_no_offenses(<<-RUBY.strip_indent)
      def bad_math
        1 / 0
      rescue StandardError => e
        Rollbar.critical(e)
      end
    RUBY
  end

  it 'does not register an offense when using `Rollbar.error with inline rescue' do
    expect_no_offenses(<<-RUBY.strip_indent)
      1 / 0 rescue Rollbar.debug('Unable to perform division')
    RUBY
  end
end
