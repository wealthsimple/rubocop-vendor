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
      class RollbarLog < Cop
        MSG = 'Use `Rollbar.%<method>s` instead of `Rollbar.log`.'

        def_node_matcher :bad_method?, <<-PATTERN
          (send
            (const nil? :Rollbar) :log
            $({str sym} _) ...)
        PATTERN

        def on_send(node)
          level = bad_method?(node)
          return unless level

          add_offense(level)
        end

        private

        def message(node)
          format(MSG, method: node.value)
        end
      end
    end
  end
end
