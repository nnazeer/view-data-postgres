module ViewData
  module Postgres
    module Controls
      module Table
        module NilKey
          def self.create(drop: nil)
            session = Session.build

            if drop
              session.execute("DROP TABLE IF EXISTS #{name}")
            end

            session.execute(<<~SQL)
              CREATE TABLE #{name} (
                some_column text,
                global_position bigserial
              )
            SQL

            session.close
          end

          def self.name
            "test_nil_key"
          end
        end
      end
    end
  end
end
