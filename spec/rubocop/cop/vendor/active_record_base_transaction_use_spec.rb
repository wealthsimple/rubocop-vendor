RSpec.describe RuboCop::Cop::Vendor::ActiveRecordBaseTransactionUse, :config do
  subject(:cop) { described_class.new }

  let(:msg) { 'Avoid using `ActiveRecord::Base.transaction, as models inheriting a subclass of ActiveRecord::Base may use a different database connection from ActiveRecord::Base.connection.' }

  it 'registers an offense for usage of ActiveRecord::Base.transaction' do
    expect_offense(<<~RUBY)
      class MyModel < ApplicationRecord
        def do_something
          ActiveRecord::Base.transaction do
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Vendor/ActiveRecordBaseTransactionUse: #{msg}
            nil
          end
        end
      end
    RUBY
  end

  it 'registers no offense for usage of MyModelClass.transaction' do
    expect_no_offenses(<<~RUBY)
      class MyModelClass < ApplicationRecord
        def do_something
          MyModelClass.transaction do
            nil
          end
        end
      end
    RUBY
  end
end
