module ViewData
  module Postgres
    module Controls
      module Table
        module OptimisticLock
          def self.create(drop: nil)
            session = Session.build

            if drop
              session.execute("DROP TABLE IF EXISTS #{name}")
            end

            session.execute(<<~SQL)
              CREATE TABLE #{name} (
                id uuid PRIMARY KEY,
                some_column text,
                global_position bigserial,
                lock_version bigint DEFAULT 0
              )
            SQL

            session.close
          end

          def self.name
            "test_optimistic_lock"
          end
        end
      end
    end
  end
end
