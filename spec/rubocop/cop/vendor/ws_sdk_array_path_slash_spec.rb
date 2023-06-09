# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::WsSdkPathArraySlash, :config do
  it 'registers an offense when using variable interpolation' do
    expect_offense(<<~RUBY)
      Ws::Service.delete(["foo/bar"])
                          ^^^^^^^^^ When switching to array arguments, you must put each path component individually
    RUBY
    expect_correction(<<~CORRECTED)
      Ws::Service.delete(["foo", "bar"])
    CORRECTED
  end

  it 'registers an offense when using interpolation in the middle' do
    expect_offense(<<~RUBY)
      Ws::Service.post(["/api/accounts/", account_id, "details/"])
                        ^^^^^^^^^^^^^^^^ When switching to array arguments, you must put each path component individually
                                                      ^^^^^^^^^^ When switching to array arguments, you must put each path component individually
    RUBY
    expect_correction(<<~CORRECTED)
      Ws::Service.post(["api", "accounts", account_id, "details"])
    CORRECTED
  end

  it 'registers an offense when using interpolation at the end' do
    expect_offense(<<~RUBY)
      Ws::Service.delete(['/api/accounts', account_id])
                          ^^^^^^^^^^^^^^^ When switching to array arguments, you must put each path component individually
    RUBY
    expect_correction(<<~CORRECTED)
      Ws::Service.delete(["api", "accounts", account_id])
    CORRECTED
  end

  it 'does not registers an offense when using array syntax without slash' do
    expect_no_offenses(<<~RUBY)
      Ws::Service.post(["api", "accounts", account_id, "details"])
    RUBY
  end
end
