module ViewData
  module Postgres
    module Controls
      module Table
        module Empty
          def self.create(drop: nil)
            session = Session.build

            if drop
              session.execute("DROP TABLE IF EXISTS #{name}")
            end

            session.execute(<<~SQL)
              CREATE TABLE #{name} (
                id uuid PRIMARY KEY,
                global_position bigserial
              )
            SQL

            session.close
          end

          def self.name
            "test_empty"
          end
        end
      end
    end
  end
end
