# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop checks for Rollbar calls outside `rescue` blocks.
      #
      # The main reason for this suggestion is that Rollbar should not be used
      # as a logger given it has a quota that is often multiple times smaller
      # than the log quota. By reporting errors outside rescue blocks
      # the developer is most likely in control of the exceptional flow and
      # won't need a stack trace.
      #
      # @example
      #   # bad
      #   Rollbar.error("Unable to sync account")
      #
      #   # good
      #   begin
      #     1 / 0
      #   rescue StandardError => exception
      #     Rollbar.error(exception, "Unable to sync account")
      #   end
      #
      class RollbarInsideRescue < Cop
        MSG = 'Only call Rollbar when handling errors inside a `rescue` block.'

        def_node_matcher :rollbar?, <<-PATTERN
          (send
            (const nil? :Rollbar) {:log :debug :info :warning :error :critical} ...)
        PATTERN

        def on_send(node)
          return unless rollbar?(node)

          current_node = node.parent
          until current_node.nil?
            return if current_node.rescue_type?

            break if current_node.def_type?
            break if current_node.class_type?

            current_node = current_node.parent
          end

          add_offense(node, location: node.children[0].loc.expression)
        end
      end
    end
  end
end
