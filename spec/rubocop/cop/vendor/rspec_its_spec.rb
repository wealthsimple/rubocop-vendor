# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RspecIts, :config do
  it 'with is_expected' do
    expect_offense(<<~RUBY)
      context "foobar" do
        its(:currency) { is_expected.to eq('CAD') }
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      end
    RUBY

    expect_correction(<<~CORRECTED)
      it 'has the correct attributes' do
        expect(subject.currency).to eq('CAD')
      end
    CORRECTED
  end

  it 'with are_expected' do
    expect_offense(<<~RUBY)
      its(:currency) { are_expected.to eq('CAD') }
      ^^^^^^^^^^^^^^ garbage
    RUBY

    expect_correction(<<~CORRECTED)
      it 'has the correct attributes' do
        expect(subject.currency).to eq('CAD')
      end
    CORRECTED
  end

  it 'with should' do
    expect_offense(<<~RUBY)
      its(:currency) { should eq('CAD') }
      ^^^^^^^^^^^^^^ garbage
    RUBY

    expect_correction(<<~CORRECTED)
      it 'has the correct attributes' do
        expect(subject.currency).to eq('CAD')
      end
    CORRECTED
  end

  it 'with should_not' do
    expect_offense(<<~RUBY)
      its(:currency) { should_not eq('CAD') }
      ^^^^^^^^^^^^^^ garbage
    RUBY

    expect_correction(<<~CORRECTED)
      it 'has the correct attributes' do
        expect(subject.currency).not_to eq('CAD')
      end
    CORRECTED
  end

  it 'with will (raise)' do
    expect_offense(<<~RUBY)
      its(:currency) { will raise_error(StandardError) }
      ^^^^^^^^^^^^^^ garbage
    RUBY

    expect_correction(<<~CORRECTED)
      it 'has the correct attributes' do
        expect { subject.currency }.to raise(StandardError) }
      end
    CORRECTED
  end

  it 'with will_not (raise)' do
    expect_offense(<<~RUBY)
      its(:currency) { will_not raise_error(StandardError) }
      ^^^^^^^^^^^^^^ garbage
    RUBY

    expect_correction(<<~CORRECTED)
      it 'has the correct attributes' do
        expect { subject.currency }.not_to raise(StandardError) }
      end
    CORRECTED
  end
end
