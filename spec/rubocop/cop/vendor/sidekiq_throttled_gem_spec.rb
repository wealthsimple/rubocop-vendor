# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::SidekiqThrottledGem, :config do
  let(:cop_config) { { 'TreatCommentsAsGroupSeparators' => treat_comments_as_group_separators } }
  let(:treat_comments_as_group_separators) { false }

  context 'When sidekiq-throttled is not in the Gemfile' do
    it 'does not register any offenses' do
      expect_no_offenses(<<~RUBY)
        gem 'rspec'
        gem 'rubocop'
      RUBY
    end
  end

  context 'When sidekiq-throttled is in the Gemfile' do
    it 'registerers an offese' do
      expect_offense(<<~RUBY)
        gem 'sidekiq-throttled'
        ^^^^^^^^^^^^^^^^^^^^^^^ Do not use the sidekiq-throttled gem. sidekiq-throttled overrides the fetcher of sidekiq-pro and sidekiq-enterprise resulting in the ability to lose jobs (switch to at-most once processing).
      RUBY
    end
  end
end
