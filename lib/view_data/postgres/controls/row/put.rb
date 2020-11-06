module ViewData
  module Postgres
    module Controls
      module Row
        module Put
          def self.call(table: nil, instances: nil, column_value: nil)
            column_value ||= Controls::Data.column_value
            table ||= Table.name
            instances ||= 1

            session = Session.build

            primary_keys = []

            instances.times do
              primary_key = PrimaryKey::UUID.example

              primary_keys << primary_key

              session.execute(<<~SQL, [primary_key, column_value])
                INSERT INTO #{table} (id, some_column) VALUES ($1, $2)
              SQL
            end

            session.close

            if primary_keys.length == 1
              return primary_keys.first
            end

            primary_keys
          end

          module CompositePrimaryKey
            def self.call
              id_1, id_2 = PrimaryKey::Composite.example
              column_value = Controls::Data.column_value
              table = Table::CompositePrimaryKey.name

              session = Session.build

              session.execute(<<~SQL, [id_1, id_2, column_value])
                INSERT INTO #{table} (id_1, id_2, some_column) VALUES ($1, $2, $3)
              SQL

              session.close

              return id_1, id_2
            end
          end
        end
      end
    end
  end
end
