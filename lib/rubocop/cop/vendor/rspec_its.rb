# frozen_string_literal: true

require 'parser/current'

module RuboCop
  module Cop
    module Vendor
      # This cop and auto-corrector replaces rspec-its with a single example.
      #
      # @example
      #   # bad
      #   its(:currency) { is_expected.to eq('CAD') }
      #
      #   # good
      #   it "has expected attributes" do
      #     expect(subject.currency).to eq('CAD')
      #   end
      #
      class RspecIts < Base
        extend AutoCorrector

        MSG = <<-STR.strip
          Switch to using non-its expectations (rspec-its is dead)
        STR

        # @!method rspec_many_its_call?(node)
        def_node_matcher :rspec_many_its_call?, <<-PATTERN
          $(begin
            ...
            (block
              <(send nil? :its ...) (args) ...>
            )
            ...
          )
        PATTERN

        # @!method rspec_its_call?(node)
        def_node_matcher :rspec_its_call?, <<-PATTERN
          (block
            (send nil? :its $_) (args) $_
          )
        PATTERN

        # @!method rspec_equal_call?(node)
        # rubocop:disable Layout/LineLength
        def_node_matcher :rspec_equal_call?, <<-PATTERN, equal_expr: Set[:is_expected, :are_expected], equal_compare: Set[:to, :not_to, :to_not]
          (send (send nil? %equal_expr) $%equal_compare $_)
        PATTERN
        # rubocop:enable Layout/LineLength

        # @!method rspec_should_call?(node)
        def_node_matcher :rspec_should_call?, <<-PATTERN, should_expr: Set[:should, :should_not]
          (send nil? $%should_expr $_)
        PATTERN

        # @!method rspec_exception_call?(node)
        def_node_matcher :rspec_exception_call?, <<-PATTERN, exception_expr: Set[:will, :will_not]
          (send nil? $%exception_expr $_)
        PATTERN

        # rubocop:disable Metrics/AbcSize
        # rubocop:disable Metrics/MethodLength
        def on_begin(node)
          begin_expr, = rspec_many_its_call?(node)
          return unless begin_expr

          add_offense(begin_expr) do |corrector|
            its_calls = begin_expr.children.select { |n| rspec_its_call?(n) }

            body_code_strs = its_calls.each_with_index.filter_map do |its_call_expr, idx|
              its_expr, body_expr = rspec_its_call?(its_call_expr)

              replacement_str = calculate_expect_str(its_expr, body_expr)
              raise ::Rubocop::Error, "did not know how to auto-correct #{body_expr}" unless replacement_str

              corrector.remove(its_call_expr.loc.expression) if idx != 0

              replacement_str
            end

            unless body_code_strs.empty?
              body = <<-RUBY
              aggregate_failures 'correct attributes and expecations' do
                #{body_code_strs.join("\n  ")}
              end
              RUBY

              corrector.replace(its_calls.first.loc.expression, body)
            end
          end
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize

        private

        def calculate_expect_str(its_expr, body_expr)
          field_name = field_name_str(its_expr) || (raise ::Rubocop::Error,
                                                          "did not know how to auto-correct #{body_expr}")

          equal_call_str(body_expr, field_name) ||
            should_call_str(body_expr, field_name) ||
            exception_call_str(body_expr, field_name) ||
            (raise ::Rubocop::Error, "did not know how to auto-correct #{body_expr}")
        end

        def field_name_str(its_expr)
          if %i[sym str].include?(its_expr.type)
            ".#{its_expr.value.to_sym}"
          elsif its_expr.array_type?
            if its_expr.children.count == 1
              its_expr.source
            else
              ".dig(#{its_expr.children.map(&:source).join(', ')})"
            end
          end
        end

        def equal_call_str(body_expr, field_name)
          equal_call = rspec_equal_call?(body_expr)
          return unless equal_call

          _comparator_expr, value_expr = equal_call

          "expect(subject#{field_name}).to #{value_expr.source}"
        end

        def should_call_str(body_expr, field_name)
          should_call = rspec_should_call?(body_expr)
          return unless should_call

          comparator_expr, value_expr = should_call
          comparator =
            case comparator_expr
            when :should
              :to
            when :should_not
              :not_to
            else
              raise ArgumentError, 'comparator was invalid on should check' # should never happen
            end

          "expect(subject#{field_name}).#{comparator} #{value_expr.source}"
        end

        def exception_call_str(body_expr, field_name)
          exception_call = rspec_exception_call?(body_expr)
          return unless exception_call

          comparator_expr, value_expr = exception_call
          comparator =
            case comparator_expr
            when :will
              :to
            when :will_not
              :not_to
            else
              raise ArgumentError, 'comparator was invalid on will check' # should never happen
            end

          "expect { subject#{field_name} }.#{comparator} #{value_expr.source}"
        end
      end
    end
  end
end
