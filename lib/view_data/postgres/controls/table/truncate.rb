module ViewData
  module Postgres
    module Controls
      module Table
        module Truncate
          def self.call(table: nil)
            table ||= Table.name

            session = Session.build

            session.execute("TRUNCATE TABLE #{table} RESTART IDENTITY")

            session.close
          end
        end
      end
    end
  end
end
