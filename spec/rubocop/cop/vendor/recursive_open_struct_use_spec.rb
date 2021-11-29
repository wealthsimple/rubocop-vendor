# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Vendor::RecursiveOpenStructUse, :config do
  context 'when using RecursiveOpenStruct' do
    ['RecursiveOpenStruct', '::RecursiveOpenStruct'].each do |klass|
      context "for #{klass}" do
        context 'when used in assignments' do
          it 'registers an offense' do
            expect_offense(<<~RUBY, klass: klass)
              a = %{klass}.new(a: 42)
                  ^{klass} Avoid using `RecursiveOpenStruct`;[...]
            RUBY
          end
        end

        context 'when inheriting from it via <' do
          it 'registers an offense' do
            expect_offense(<<~RUBY, klass: klass)
              class SubClass < %{klass}
                               ^{klass} Avoid using `RecursiveOpenStruct`;[...]
              end
            RUBY
          end
        end

        context 'when inheriting from it via Class.new' do
          it 'registers an offense' do
            expect_offense(<<~RUBY, klass: klass)
              SubClass = Class.new(%{klass})
                                   ^{klass} Avoid using `RecursiveOpenStruct`;[...]
            RUBY
          end
        end
      end
    end
  end

  context 'when using custom namespaced RecursiveOpenStruct' do
    context 'when inheriting from it' do
      specify { expect_no_offenses('class A < SomeNamespace::RecursiveOpenStruct; end') }
    end

    context 'when defined in custom namespace' do
      context 'when class' do
        specify do
          expect_no_offenses(<<~RUBY)
            module SomeNamespace
              class RecursiveOpenStruct
              end
            end
          RUBY
        end
      end

      context 'when module' do
        specify do
          expect_no_offenses(<<~RUBY)
            module SomeNamespace
              module RecursiveOpenStruct
              end
            end
          RUBY
        end
      end
    end

    context 'when used in assignments' do
      it 'registers no offense' do
        expect_no_offenses(<<~RUBY)
          a = SomeNamespace::RecursiveOpenStruct.new
        RUBY
      end
    end
  end

  context 'when not using RecursiveOpenStruct' do
    it 'registers no offense', :aggregate_failures do
      expect_no_offenses('class A < B; end')
      expect_no_offenses('a = 42')
    end
  end
end
