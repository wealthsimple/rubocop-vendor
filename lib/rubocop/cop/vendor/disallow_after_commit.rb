# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      class DisallowAfterCommit < Base
        extend AutoCorrector

        NO_METH_MSG = "You should not use `%<old>s` %<desc>s"
        NO_METHS = {
          after_commit: "generally you want `before_commit` as after_commit is non-transactional in guarentees of running",
        }.freeze

        def on_send(node)
          name = node.method_name
          if NO_METHS.key?(name)
            add_offense(node, message: format(NO_METH_MSG, old: name, desc: NO_METHS[name]))
          end
        end
      end
    end
  end
end
