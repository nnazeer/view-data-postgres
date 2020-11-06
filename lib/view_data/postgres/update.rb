module ViewData
  module Postgres
    class Update
      include Dependency
      include Log::Dependency

      dependency :session, Session

      def self.build(session: nil)
        instance = new
        instance.configure(session: session)
        instance
      end

      def configure(session: nil)
        Session.configure(self, session: session)
      end

      def self.configure(receiver, session: nil, attr_name: nil)
        attr_name ||= :update
        instance = build(session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def self.call(create_command, session: nil)
        instance = build(session: session)
        instance.(create_command)
      end

      def call(update)
        table_name = update.name

        logger.trace { "Updating row (Table: #{table_name}, Identifier: #{update.identifier.inspect})" }

        pkey_columns = []
        pkey_values = []

        if !update.identifier.nil?
          pkey_columns = update.identifier.keys.map(&:to_sym)
          pkey_values = update.identifier.values
        end

        strict = pkey_columns.include?(:lock_version)

        data_columns = update.data.keys
        data_values = update.data.values

        set_clause = data_columns.map.with_index do |column, index|
          quoted_column = double_quote(column)

          reference = index + 1

          "#{quoted_column} = $#{reference}"
        end

        pkey_clause = pkey_columns.map.with_index do |column, index|
          quoted_column = double_quote(column)

          reference = index + data_columns.count + 1

          "#{quoted_column} = $#{reference}"
        end

        values = data_values + pkey_values

        statement = <<~SQL.chomp
          UPDATE #{double_quote(table_name)}
          SET #{set_clause * ', '}
          WHERE #{pkey_clause * ' AND '}
        SQL

        logger.trace { "Updating row (Table: #{table_name}, Identifier: #{update.identifier.inspect})" }
        logger.trace(tag: :data) { "SQL: #{statement}" }
        logger.trace(tag: :data) { values.pretty_inspect }

        result = session.execute(statement, values)

        if result.cmd_tuples == 0 && strict
          raise ExpectedVersion::Error, 'Wrong expected version'
        end

        logger.info { "Updated row (Table: #{table_name}, Identifier: #{update.identifier.inspect})" }
        logger.info(tag: :data) { "SQL: #{statement}" }
        logger.info(tag: :data) { values.pretty_inspect }
      end

      def double_quote(text)
        "\"#{text}\""
      end
    end
  end
end
