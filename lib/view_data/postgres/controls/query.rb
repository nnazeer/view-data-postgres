module ViewData
  module Postgres
    module Controls
      module Query
        def self.example(table: nil, statement: nil, parameters: nil)
          table ||= Table.name
          statement ||= sql_statement(table)

          query = ViewData::Postgres::Query.new
          query.name = table
          query.statement = statement
          query.parameters = parameters
          query
        end

        def self.sql_statement(table_name)
          <<~SQL.chomp
            SELECT *
            FROM #{table_name}
          SQL
        end

        module Empty
          def self.example
            table = Table::Empty.name
            Query.example(table: table)
          end
        end

        module Parameters
          def self.example(id:)
            table = Table.name
            statement = sql_statement(table)
            parameters = [id]

            Query.example(table: table, statement: statement, parameters: parameters)
          end

          def self.sql_statement(table_name)
            <<~SQL.chomp
              SELECT *
              FROM #{table_name}
              WHERE id = $1::uuid
            SQL
          end
        end

        module Position
          def self.example(table: nil)
            table ||= Table.name
            statement = sql_statement(table)

            Query.example(table: table, statement: statement)
          end

          def self.sql_statement(table_name)
            <<~SQL.chomp
              SELECT *
              FROM #{table_name}
              WHERE global_position > $1::bigint
              ORDER BY global_position ASC
              LIMIT $2::bigint
            SQL
          end

          module SomeColumn
            def self.example(column_value:)
              table = Table.name
              statement = sql_statement(table)
              parameters = [column_value]

              Query.example(table: table, statement: statement, parameters: parameters)
            end

            def self.sql_statement(table_name)
              <<~SQL.chomp
                SELECT *
                FROM #{table_name}
                WHERE some_column = $3::varchar
                AND global_position > $1::bigint
                ORDER BY global_position ASC
                LIMIT $2::bigint
              SQL
            end
          end

          module Parameters
            def self.example(id:)
              table = Table.name
              statement = sql_statement(table)
              parameters = [id]

              Query.example(table: table, statement: statement, parameters: parameters)
            end

            def self.sql_statement(table_name)
              <<~SQL.chomp
                SELECT *
                FROM #{table_name}
                WHERE id = $3::uuid
                AND global_position > $1::bigint
                ORDER BY global_position ASC
                LIMIT $2::bigint
              SQL
            end
          end
        end
      end
    end
  end
end
