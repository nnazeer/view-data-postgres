module ViewData
  module Postgres
    class Session
      module Substitute
        def self.build
          instance = Session.build
          instance
        end

        class Session <::ViewData::Postgres::Session
          def self.build
            instance = new
            instance
          end

          def execute(sql_command, params=nil)
            cmd_tuples = 1
            Result.new(cmd_tuples)
          end

          Result = Struct.new(:cmd_tuples)
        end
      end
    end
  end
end
