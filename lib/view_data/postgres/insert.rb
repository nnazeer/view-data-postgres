module ViewData
  module Postgres
    class Insert
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
        attr_name ||= :insert
        instance = build(session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def self.call(create_command, session: nil)
        instance = build(session: session)
        instance.(create_command)
      end

      def call(create, strict: nil)
        table_name = create.name

        logger.trace { "Inserting row (Table: #{table_name}, Identifier: #{create.identifier.inspect})" }

        pkey_columns = []
        pkey_values = []

        if !create.identifier.nil?
          pkey_columns = create.identifier.keys.map(&:to_sym)
          pkey_values = create.identifier.values
        end

        data_columns = create.data.keys
        data_values = create.data.values

        if create.identifier.nil?
          columns = data_columns
        else
          columns = pkey_columns + data_columns
        end

        quoted_columns = columns.map do |column|
          double_quote(column)
        end

        values = pkey_values + data_values

        values_clause = values.count.times.map do |i|
          "$#{i + 1}"
        end

        statement = <<~SQL.chomp
          INSERT INTO #{double_quote(table_name)} (#{quoted_columns * ', '})
          VALUES (#{values_clause * ', '})
        SQL

        begin
          logger.trace { "Inserting row (Table: #{table_name}, Identifier: #{create.identifier.inspect})" }
          logger.trace(tag: :data) { "SQL: #{statement}" }
          logger.trace(tag: :data) { values.pretty_inspect }

          session.execute(statement, values)

          logger.info { "Inserted row (Table: #{table_name}, Identifier: #{create.identifier.inspect})" }
          logger.info(tag: :data) { "SQL: #{statement}" }
          logger.info(tag: :data) { values.pretty_inspect }
        rescue PG::UniqueViolation
          if strict
            raise UniqueViolation
          end
        end
      end

      def double_quote(text)
        "\"#{text}\""
      end

      UniqueViolation = Class.new(PG::UniqueViolation)
    end
  end
end
