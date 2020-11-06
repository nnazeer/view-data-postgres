module ViewData
  module Postgres
    module Controls
      module MessageData
        module Read
          def self.example(id: nil)
            if id == :none
              id = nil
            else
              id ||= self.id
            end

            message_data = MessageClass.example.build

            message_data.id = id
            message_data.some_column = some_column

            message_data
          end

          def self.id
            PrimaryKey::UUID.example
          end

          def self.some_column
            Data.column_value
          end
        end
      end
    end
  end
end
