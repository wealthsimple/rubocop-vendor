# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RecursiveOpenStructGem, :config do
  let(:cop_config) { { 'TreatCommentsAsGroupSeparators' => treat_comments_as_group_separators } }
  let(:treat_comments_as_group_separators) { false }

  context 'When recursive-open-struct is not in the Gemfile' do
    it 'does not register any offenses' do
      expect_no_offenses(<<~RUBY)
        gem 'rspec'
        gem 'rubocop'
      RUBY
    end
  end

  context 'When recursive-open-struct is in the Gemfile' do
    it 'registerers an offese' do
      expect_offense(<<~RUBY)
        gem 'recursive-open-struct'
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use the recursive-open-struct gem. RecrusiveOpenStruct inherits from OpenStruct, which is now officially discouraged from usage due to performance, version compatibility, and security issues.
      RUBY
    end
  end
end
