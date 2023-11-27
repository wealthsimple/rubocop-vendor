# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::DisallowAfterCommit, :config do
  it 'registers an offense when using `after_commit` with no args' do
    expect_offense(<<~RUBY)
      after_commit
      ^^^^^^^^^^^^ Do not not use `after_commit` use `before_commit` because after_commit is non-transactional an may not run
    RUBY
  end

  it 'registers an offense when using `after_commit` with args' do
    expect_offense(<<~RUBY)
      after_commit :foo_bar
      ^^^^^^^^^^^^^^^^^^^^^ Do not not use `after_commit` use `before_commit` because after_commit is non-transactional an may not run
    RUBY
  end
end
