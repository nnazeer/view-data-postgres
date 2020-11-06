module ViewData
  module Postgres
    module Controls
      module Table
        module Password
          def self.create(drop: nil)
            session = Session.build

            if drop
              session.execute("DROP TABLE IF EXISTS #{name}")
            end

            session.execute(<<~SQL)
              CREATE TABLE #{name} (
                id uuid PRIMARY KEY,
                password_test text,
                global_position bigserial
              )
            SQL

            session.close
          end

          def self.name
            "test_password"
          end
        end
      end
    end
  end
end
