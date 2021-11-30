# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop checks for non-error usage of Rollbar and suggests using
      # `Rails.logger` instead.
      #
      # The main reason for this suggestion is that Rollbar has a quota that is
      # often multiple times smaller than the log quota and it may become
      # expensive, also an error tracker should *not* be used as a logger.
      #
      # @example
      #   # bad
      #   Rollbar.info("Stale message")
      #
      #   # good
      #   Rails.logger.info("Stale message")
      #
      class RollbarLogger < Base
        MSG = 'Use `Rails.logger` for `debug`, `info` or `warning` calls.'

        # @!method bad_method?(node)
        def_node_matcher :bad_method?, <<-PATTERN
          (send (const nil? :Rollbar) {:debug :info :warning} {str hash})
        PATTERN

        def on_send(node)
          return unless bad_method?(node)

          add_offense(node, location: node.children[0].loc.expression)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.children[0].loc.expression, 'Rails.logger')
          end
        end
      end
    end
  end
end
