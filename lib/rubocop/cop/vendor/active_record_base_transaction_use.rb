# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # Flags uses of ActiveRecord::Base.transaction,
      # as subclasses of ActiveRecord::Base may use a different
      # database connection.
      #
      # This becomes relevant if, for instance, your application
      # defines models or any subclass of ActiveRecord::Base
      # specifying connection configurations, e.g. using `connects_to`.
      #
      # The guarantee that transaction connection matches the
      # model connection is strongest when `MyModelClass.transaction`
      # wraps database operations on instances of MyModelClass only.
      #
      # If multiple model classes are involved in a .transaction
      # call, `.transaction` only needs to be called on one of them,
      # or a common ancestor sharing the same connection
      # if both models share the same underlying connection.
      #
      # If not, a workaround would be to open a transaction on both
      # model classes.
      #
      # @example
      #
      #   # bad
      #   ActiveRecord::Base.transaction do
      #     ... database operations
      #   end
      #
      #   # good
      #   MyModelClass.transaction do
      #     ... database operations on instances of MyModelClass
      #   end
      #
      #   # also good
      #   my_model_instance.with_lock do
      #     ... database operations on my_model_instance
      #   end
      #
      #   # good if and only if both models share a database connection
      #   MyModelClass.transaction do
      #     ... database operations on instances of MyModelClass
      #     ... database operations on instances of MyOtherModelClass
      #   end
      #
      #   # good if and only if ApplicationRecord shares a database
      #   # connection with all models involved
      #   ApplicationRecord.transaction do
      #     ... database operations on instances of MyModelClass
      #     ... database operations on instances of MyOtherModelClass
      #   end
      #
      #   # good if the models do not share a database connection
      #   MyModelClass.transaction do
      #     MyOtherModelClass.transaction do
      #       ... database operations on instances of MyModelClass
      #       ... database operations on instances of MyOtherModelClass
      #     end
      #   end
      #
      class ActiveRecordBaseTransactionUse < Base
        MSG = 'Avoid using `ActiveRecord::Base.transaction, as models inheriting a subclass of ActiveRecord::Base may use a different database connection from ActiveRecord::Base.connection.'

        # @!method uses_active_record_base?(node)
        def_node_matcher :uses_active_record_base?, <<-PATTERN
          (const (const {nil? cbase} :ActiveRecord) :Base)
        PATTERN

        def on_send(node)
          receiver_node, method_name = *node

          return unless uses_active_record_base?(receiver_node) && method_name == :transaction

          add_offense(node)
        end
      end
    end
  end
end
