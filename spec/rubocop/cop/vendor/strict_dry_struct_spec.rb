# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::StrictDryStruct, :config, :config do
  it 'registers an offense when using Dry::Struct without strict' do
    expect_offense(<<~RUBY)
      class ExampleStruct < Dry::Struct
                            ^^^^^^^^^^^ Avoid using `Dry::Struct` without schema schema.strict
        attribute :example_attribute, T::String
      end
    RUBY
  end

  it 'does not register an offense when using Dry::Struct with strict' do
    expect_no_offenses(<<~RUBY)
      class ExampleStruct < Dry::Struct
        schema schema.strict

        attribute :example_attribute, T::String
      end
    RUBY
  end
end
