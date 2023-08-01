# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::WsSdkPathInjection, :config do
  before do
    # force auto-correction in test suite
    allow(described_class).to receive(:ws_sdk_supports_arrays?).and_return(true)
  end

  it 'registers an offense when using variable interpolation' do
    expect_offense(<<~RUBY)
      Ws::Service.delete(account_id)
                         ^^^^^^^^^^ Use of paths with interpolated values is dangerous, as path injection can occur; prefer to use array of each path component
    RUBY

    expect_correction(<<~CORRECTED)
      Ws::Service.delete([account_id])
    CORRECTED
  end

  it 'registers an offense when using interpolation in the middle' do
    expect_offense(<<~RUBY)
      Ws::Service.post("/api/accounts/\#{account_id}/details")
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use of paths with interpolated values is dangerous, as path injection can occur; prefer to use array of each path component
    RUBY

    expect_correction(<<~CORRECTED)
      Ws::Service.post(["api", "accounts", account_id, "details"])
    CORRECTED
  end

  it 'registers an offense when using interpolation at the end' do
    expect_offense(<<~RUBY)
      Ws::Service.delete("/api/accounts/\#{account_id}")
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use of paths with interpolated values is dangerous, as path injection can occur; prefer to use array of each path component
    RUBY

    expect_correction(<<~CORRECTED)
      Ws::Service.delete(["api", "accounts", account_id])
    CORRECTED
  end

  it 'corrects with additional arguments' do
    expect_offense(<<~RUBY)
      Ws::Service.put("/api/accounts/\#{account_id}", { body: "123" })
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use of paths with interpolated values is dangerous, as path injection can occur; prefer to use array of each path component
    RUBY

    expect_correction(<<~CORRECTED)
      Ws::Service.put(["api", "accounts", account_id], { body: "123" })
    CORRECTED
  end

  it 'corrects with complicated interpolations' do
    expect_offense(<<~RUBY)
      Ws::Service.put("/api/accounts/\#{my_method(account_id.to_i)}", "123")
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use of paths with interpolated values is dangerous, as path injection can occur; prefer to use array of each path component
    RUBY

    expect_correction(<<~CORRECTED)
      Ws::Service.put(["api", "accounts", my_method(account_id.to_i)], "123")
    CORRECTED
  end

  it 'does not registers an offense when using array syntax' do
    expect_no_offenses(<<~RUBY)
      Ws::Service.post(["api", "accounts", account_id, "details"])
    RUBY
  end
end
