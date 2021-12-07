# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop checks for interpolated message when calling `Rollbar.error`
      # and suggests sending extra fields as hash parameter instead.
      #
      # The main reason for this suggestion is that Rollbar will have a harder
      # time grouping messages that are dynamic.
      #
      # @example
      #   # bad
      #   Rollbar.error(e, "Unable to sync account #{account.id}")
      #
      #   # good
      #   Rollbar.error(e, "Unable to sync account", account_id: account.id)
      #
      class RollbarInterpolation < Base
        MSG = 'Send extra fields as hash parameter instead of interpolated message.'

        # @!method bad_method?(node)
        def_node_matcher :bad_method?, <<-PATTERN
          (send
            (const nil? :Rollbar) {:error :critical}
            (...) $(dstr ...) ...)
        PATTERN

        def on_send(node)
          interpolated_string = bad_method?(node)
          return unless interpolated_string

          add_offense(interpolated_string)
        end
      end
    end
  end
end
