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
      #   # good
      #   class ApplicationController < ActionController::Base
      #     rescue_from InvalidRecord do |e|
      #       Rollbar.error(e)
      #     end
      #   end
      #
      class RollbarInsideRescue < Cop
        MSG = 'Only call Rollbar when handling errors inside a `rescue` block.'

        # @!method rollbar?(node)
        def_node_matcher :rollbar?, <<-PATTERN
          (send
            (const nil? :Rollbar) {:log :debug :info :warning :error :critical} ...)
        PATTERN

        # @!method active_support_rescuable_block?(node)
        def_node_matcher :active_support_rescuable_block?, <<-PATTERN
          (block
            (send nil? :rescue_from ...) ...)
        PATTERN

        def on_send(node)
          return unless rollbar?(node)
          return if in_rescue_block?(node)

          add_offense(node, location: node.children[0].loc.expression)
        end

        def in_rescue_block?(node)
          current_node = node

          while (current_node = current_node.parent)
            return true if current_node.rescue_type?
            return true if active_support_rescuable_block?(current_node)

            break if current_node.def_type?
            break if current_node.class_type?
          end
        end
      end
    end
  end
end
