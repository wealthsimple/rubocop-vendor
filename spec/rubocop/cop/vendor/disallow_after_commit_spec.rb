# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::DisallowAfterCommit, :config do
  it 'registers an offense when using `after_commit` with no args' do
    expect_offense(<<~RUBY)
      after_commit
      ^^^^^^^^^^^^ You should not use `after_commit` generally you want `before_commit` as after_commit is non-transactional in guarentees of running
    RUBY
  end

  it 'registers an offense when using `after_commit` with args' do
    expect_offense(<<~RUBY)
      after_commit :foo_bar
      ^^^^^^^^^^^^^^^^^^^^^ You should not use `after_commit` generally you want `before_commit` as after_commit is non-transactional in guarentees of running
    RUBY
  end
end
