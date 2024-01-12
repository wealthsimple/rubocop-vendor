# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RollbarInterpolation, :config do
  it 'registers an offense when using `Rollbar.error` with interpolated string' do
    expect_offense(<<~'RUBY')
      Rollbar.error(e, "Unable to sync account #{account[:id]}")
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Send extra fields as hash parameter instead of interpolated message.
    RUBY
  end

  it 'registers an offense when using `Rollbar.error` with interpolated string and hash' do
    expect_offense(<<~'RUBY')
      Rollbar.error(e, "Failed to sync account #{id}", { account_id: id })
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Send extra fields as hash parameter instead of interpolated message.
    RUBY
  end

  it 'does not register an offense when using `Rollbar.error` with plain string' do
    expect_no_offenses(<<~RUBY)
      Rollbar.error(e, 'Malformed message')
    RUBY
  end
end
