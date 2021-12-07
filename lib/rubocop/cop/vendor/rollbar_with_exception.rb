# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop checks for the exception *not* being passed when calling
      # `Rollbar.error` or `Rollbar.critical` and suggests sending it as
      # the first parameter.
      #
      # The main reason for this suggestion is that Rollbar will display the
      # stack trace along with the error message which will be useful
      # when debugging the issue. If the error is not needed consider using the
      # logger instead.
      #
      # @example
      #   # bad
      #   Rollbar.error("Unable to sync account")
      #
      #   # good
      #   Rollbar.error(exception, "Unable to sync account")
      #
      class RollbarWithException < Base
        include RangeHelp

        MSG = 'Send exception as first parameter when calling `error` or `critical`.'

        # @!method bad_method?(node)
        def_node_matcher :bad_method?, <<-PATTERN
          (send
            (const nil? :Rollbar) {:error :critical}
            !$(lvar _)
            ...)
        PATTERN

        def on_send(node)
          first_param = bad_method?(node)
          return unless first_param

          begin_pos = first_param.loc.expression.begin.begin_pos

          add_offense(range_between(begin_pos, begin_pos + 1))
        end
      end
    end
  end
end
