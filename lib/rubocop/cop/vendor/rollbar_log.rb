# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop checks for `Rollbar.log` usage and suggests specialized
      # method calls instead.
      #
      # The main reason for this suggestion is consistency.
      #
      # @example
      #   # bad
      #   Rollbar.log('info', 'Stale message')
      #
      #   # good
      #   Rollbar.info('Stale message')
      #
      class RollbarLog < Base
        include RangeHelp
        extend AutoCorrector

        MSG = 'Use `Rollbar.%<method>s` instead of `Rollbar.log`.'

        # @!method bad_method?(node)
        def_node_matcher :bad_method?, <<-PATTERN
          (send
            (const nil? :Rollbar) :log
            ({str sym} _) ...)
        PATTERN

        def on_send(node)
          return unless bad_method?(node)

          range = offending_range(node)
          method = node.children[2].value

          add_offense(range, message: format(MSG, method: method)) do |corrector|
            replacement = "#{method}#{range.source.include?('(') ? '(' : ' '}"
            corrector.replace(range, replacement)
          end
        end

        private

        def offending_range(node)
          range_between(
            node.children[0].loc.last_column + 1,
            node.children[3].loc.column
          )
        end
      end
    end
  end
end
