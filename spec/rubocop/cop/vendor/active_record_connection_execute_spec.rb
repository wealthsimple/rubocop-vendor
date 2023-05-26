# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::ActiveRecordConnectionExecute, :config do
  it 'registers an offense when using `ActiveRecord::Base.connection.execute`' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.connection.execute('SELECT * FROM users')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use of `ActiveRecord::Connection#execute` returns manually memory managed object, consider using `select_one`, `select_all`, `insert`, `update`, `delete`. If necessary, you can also use `exec_query`, `exec_insert`, `exec_update`, `exec_delete`.
    RUBY
  end

  it 'registers an offense when using `ApplicationRecord.connection.execute`' do
    expect_offense(<<~RUBY)
      ApplicationRecord.connection.execute('SELECT * FROM users')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use of `ActiveRecord::Connection#execute` returns manually memory managed object, consider using `select_one`, `select_all`, `insert`, `update`, `delete`. If necessary, you can also use `exec_query`, `exec_insert`, `exec_update`, `exec_delete`.
    RUBY
  end

  it 'registers an offense when using `User.connection.execute`' do
    expect_offense(<<~RUBY)
      User.connection.execute('SELECT * FROM users')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use of `ActiveRecord::Connection#execute` returns manually memory managed object, consider using `select_one`, `select_all`, `insert`, `update`, `delete`. If necessary, you can also use `exec_query`, `exec_insert`, `exec_update`, `exec_delete`.
    RUBY
  end

  it 'does not registers an offense when using `User.connection.select_all`' do
    expect_no_offenses(<<~RUBY)
      User.connection.select_all('SELECT * FROM users')
    RUBY
  end
end
