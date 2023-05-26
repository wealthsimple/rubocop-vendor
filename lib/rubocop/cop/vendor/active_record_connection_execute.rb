# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop checks for `ActiveRecord::Connection#execute` usage and suggests
      # using non-manually memory managed objects instead.
      #
      # The main reason for this is this is a common way to leak memory in a Ruby on Rails application.
      # see {
      # https://github.com/rails/rails/blob/a19b13b61f7af612569943ec7d536185cbec875c/activerecord/lib/active_record/connection_adapters/abstract/database_statements.rb#L127
      # ActiveRecord documentation
      # }.
      #
      # @example
      #   # bad
      #   ActiveRecord::Base.connection.execute('SELECT * FROM users')
      #   ApplicationRecord.connection.execute('SELECT * FROM users')
      #   User.connection.execute('SELECT * FROM users')
      #
      #   # good
      #   ActiveRecord::Base.connection.select_all('SELECT * FROM users')
      #   ApplicationRecord.connection.select_all('SELECT * FROM users')
      #   User.connection.select_all('SELECT * FROM users')
      #
      class ActiveRecordConnectionExecute < Base
        MSG = <<-STR.strip
          Use of `ActiveRecord::Connection#execute` returns manually memory managed object, consider using `select_one`, `select_all`, `insert`, `update`, `delete`. If necessary, you can also use `exec_query`, `exec_insert`, `exec_update`, `exec_delete`.
        STR

        # @!method connection_execute_method_call?(node)
        def_node_matcher :connection_execute_method_call?, <<-PATTERN
          (send (send _ :connection) :execute ...)
        PATTERN

        def on_send(node)
          return unless connection_execute_method_call?(node)

          add_offense(node)
        end
      end
    end
  end
end
