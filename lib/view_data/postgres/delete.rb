module ViewData
  module Postgres
    class Delete
      include Dependency
      include Log::Dependency

      dependency :session, Session
      dependency :telemetry, Telemetry

      def self.build(session: nil)
        instance = new
        instance.configure(session: session)
        instance
      end

      def configure(session: nil)
        Session.configure(self, session: session)
        ::Telemetry.configure(self)
      end

      def self.configure(receiver, session: nil, attr_name: nil)
        attr_name ||= :delete
        instance = build(session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def self.call(create_command, session: nil)
        instance = build(session: session)
        instance.(create_command)
      end

      def call(delete)
        table_name = delete.name

        logger.trace { "Deleting row (Table: #{table_name}, Identifier: #{delete.identifier.inspect})" }

        pkey_columns = []
        pkey_values = []

        if !delete.identifier.nil?
          pkey_columns = delete.identifier.keys.map(&:to_sym)
          pkey_values = delete.identifier.values
        end

        strict = pkey_columns.include?(:lock_version)

        pkey_clause = pkey_columns.map.with_index do |column, index|
          quoted_column = double_quote(column)

          reference = index + 1

          "#{quoted_column} = $#{reference}"
        end

        statement = <<~SQL.chomp
          DELETE FROM #{double_quote(table_name)}
          WHERE #{pkey_clause * ' AND '}
        SQL

        logger.trace { "Deleting row (Table: #{table_name}, Identifier: #{delete.identifier.inspect})" }
        logger.trace(tag: :data) { "SQL: #{statement}" }
        logger.trace(tag: :data) { pkey_values.pretty_inspect }

        result = session.execute(statement, pkey_values)

        if result.cmd_tuples == 0 && strict
          raise ExpectedVersion::Error, 'Wrong expected version'
        end

        logger.info { "Deleted row (Table: #{table_name}, Identifier: #{delete.identifier.inspect})" }
        logger.info(tag: :data) { "SQL: #{statement}" }
        logger.info(tag: :data) { pkey_values.pretty_inspect }

        telemetry.record(:deleted)
      end

      def double_quote(text)
        "\"#{text}\""
      end
    end
  end
end
